//
//  NCXParser.swift
//  R2Streamer
//
//  Created by Alexandre Camilleri on 3/17/17.
//  Copyright © 2017 Readium. All rights reserved.
//

import Foundation
import AEXML

/// From IDPF a11y-guidelines content/nav/toc.html :
/// "The NCX file is allowed for forwards compatibility purposes only. An EPUB 2
/// reading systems may open an EPUB 3 publication, but it will not be able to 
/// use the new navigation document format.
/// You can ignore the NCX file if your book won't render properly as EPUB 2 
/// content, or if you aren't targeting cross-compatibility."
public class NCXParser {

    /// [SUGAR] on top of nodeArray.
    /// Return the data representation of the table of contents (toc)
    /// informations contained in the NCX Document.
    ///
    /// - Parameter document: The NCX Document.
    /// - Returns: The data representation of the table of contents (toc).
    internal func tableOfContents(fromNcxDocument document: AEXMLDocument) -> [Link] {
        let navMapElement = document.root["navMap"]
        let tableOfContentsNodes = nodeArray(forNcxElement: navMapElement, ofType: "navPoint")

        return tableOfContentsNodes
    }

    /// [SUGAR] on top of nodeArray.
    /// Return the data representation of the pageList informations contained in
    /// the NCX Document.
    ///
    /// - Parameter document: The NCX Document.
    /// - Returns: The data representation of the pageList.
    internal func pageList(fromNcxDocument document: AEXMLDocument) -> [Link] {
        let pageListElement = document.root["pageList"]
        let pageListNodes = nodeArray(forNcxElement: pageListElement, ofType: "pageTarget")

        return pageListNodes
    }

    /// Generate an array of Link elements representing the XML structure of the
    /// given NCX element. Each of them possibly having children.
    ///
    /// - Parameters:
    ///   - ncxElement: The NCX XML element Object.
    ///   - type: The sub elements names (e.g. 'navPoint' for 'navMap',
    ///           'pageTarget' for 'pageList'.
    /// - Returns: The Object representation of the data contained in the given
    ///            NCX XML element.
    fileprivate func nodeArray(forNcxElement element: AEXMLElement,
                               ofType type: String) -> [Link]
    {
        // The "to be returned" node array.
        var newNodeArray = [Link]()

        // Find the elements of `type` in the XML element.
        guard let elements = element[type].all else {
            return []
        }
        // For each element create a new node of type `type`.
        for element in elements {
            let newNode = node(using: element, ofType: type)

            newNodeArray.append(newNode)
        }
        return newNodeArray
    }

    /// [RECURSIVE]
    /// Create a node(`Link`) from a <navPoint> element.
    /// If there is a nested element, recursively handle it.
    ///
    /// - Parameter element: The <navPoint> from the NCX Document.
    /// - Returns: The generated node(`Link`).
    fileprivate func node(using element: AEXMLElement, ofType type: String) -> Link {
        var newNode = Link()

        // Get current node informations.
        newNode.href = element["content"].attributes["src"]
        newNode.title = element["navLabel"]["text"].value
        // Retrieve the children of the current node. // FIXME: really usefull?
        if let childrenNodes = element[type].all {
            // Add current node children recursively.
            for childNode in childrenNodes {
                newNode.children.append(node(using: childNode, ofType: type))
            }
        }
        return newNode
    }
}
