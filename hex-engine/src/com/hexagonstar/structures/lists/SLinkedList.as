/* * hexagonlib - Multi-Purpose ActionScript 3 Library. *       __    __ *    __/  \__/  \__    __ *   /  \__/HEXAGON \__/  \ *   \__/  \__/  LIBRARY _/ *            \__/  \__/ * * Licensed under the MIT License *  * Permission is hereby granted, free of charge, to any person obtaining a copy of * this software and associated documentation files (the "Software"), to deal in * the Software without restriction, including without limitation the rights to * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of * the Software, and to permit persons to whom the Software is furnished to do so, * subject to the following conditions: *  * The above copyright notice and this permission notice shall be included in all * copies or substantial portions of the Software. *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */package com.hexagonstar.structures.lists{	import com.hexagonstar.structures.ICollection;	import com.hexagonstar.structures.IIterator;		/**	 * A singly linked list, i.e. a list in which every element keeps a link to	 * it's next but not to it's previous element.	 */	public class SLinkedList extends AbstractList implements IList	{		//-----------------------------------------------------------------------------------------		// Properties		//-----------------------------------------------------------------------------------------				/** @private */		protected var _first:Node;		/** @private */		protected var _last:Node;						//-----------------------------------------------------------------------------------------		// Constructor		//-----------------------------------------------------------------------------------------				/**		 * Creates a new SinglyLinkedList instance. If any elements are specified, they are		 * being added to the new list. Otherwise an empty list is created.		 * 		 * @param elements Elements to add to the list.		 */		public function SLinkedList(...elements)		{			_size = 0;			_first = _last = null;						if (elements.length > 0)			{				append.apply(this, elements);			}		}						//-----------------------------------------------------------------------------------------		// Query Operations		//-----------------------------------------------------------------------------------------				/**		 * @inheritDoc		 */		override public function getElementAt(index:int):*		{			if (index < 0 || index >= _size)			{				return throwIndexOutOfBoundsException(index);			}			else			{				var current:Node = _first;				var i:int = 0;				while (i < index)				{					current = current.next;					i++;				}				return current.data;			}		}						/**		 * Checks if the list contains the specified element. If the element exists in the		 * list, true is returned, otherwise false.		 * 		 * @param element The element whose presence in the list is to be tested.		 * @return true if the list contains the specified element, otherwise false.		 */		override public function contains(element:*):Boolean		{			if (_size < 1)			{				return false;			}						var node:Node = _first;			while (node)			{				if (node.data === element)				{					return true;				}				node = node.next;			}			return false;		}						/**		 * @inheritDoc		 */		public function equals(collection:ICollection):Boolean		{			if (collection is SLinkedList)			{				var l:SLinkedList = SLinkedList(collection);				var i:int = l.size;				if (i != _size) return false;								while (i--)				{					if (l.getElementAt(i) != getElementAt(i))					{						return false;					}				}								return true;			}						return false;		}						/**		 * @inheritDoc		 */		public function get iterator():IIterator		{			return new ListIterator(this);		}						/**		 * @inheritDoc		 */		public function indexOf(element:*):int		{			var current:Node = _first;			var i:int = 0;						while (i < _size)			{				if (current.data === element) return i;				current = current.next;				i++;			}			return -1;		}						/**		 * @inheritDoc		 */		public function join(separator:String = ","):String		{			if (_size < 1) return null;						var s:String = "";			var node:Node = _first;			var i:int = 0;						while (node)			{				s += "" + node.data;				if (i < _size - 1)				{					s += separator;				}				node = node.next;				i++;			}			return s;		}						/**		 * @inheritDoc		 */		public function clone():*		{			var list:SLinkedList = new SLinkedList();			list.addAll(this);			return list;		}						/**		 * @inheritDoc		 */		public function toArray():Array		{			var a:Array = [];			var node:Node = _first;						while (node)			{				a.push(node.data);				node = node.next;			}			return a;		}						/**		 * @inheritDoc		 */		public function dump():String		{			var s:String = toString();			var node:Node = _first;			var i:int = 0;						while (node)			{				s += "\n[" + i + ":" + node.data + "]";				if (node.next)				{					s += " > ";				}				node = node.next;				i++;			}						return s;		}						//-----------------------------------------------------------------------------------------		// Modification Operations		//-----------------------------------------------------------------------------------------				/**		 * Adds the specified element to the end of the list. This does the same like		 * calling append() with only one parameter. It is recommended to use the append()		 * method instead. This methods exists here merely for the purpose to follow the		 * collection interface.		 * 		 * @see #append		 * @param element The element to add to the list.		 * @return true if the element was added successfully.		 */		public function add(element:*):Boolean		{			return append(element);		}						/**		 * @inheritDoc		 */		override public function append(...elements):Boolean		{			var l:int = elements.length;			if (l < 1) return false;			var node:Node = new Node(elements[0]);						if (_first)			{				_last.next = node;				_last = node;			}			else			{				_first = _last = node;			}						if (l > 1)			{				for (var i:int = 1; i < l; i++)				{					node = new Node(elements[i]);					_last.next = node;					_last = node;				}			}						_size += l;			return true;		}						/**		 * @inheritDoc		 */		public function prepend(...elements):Boolean		{			var l:int = elements.length;			if (l < 1) return false;			var node:Node = new Node(elements[int(l - 1)]);						if (_first)			{				node.next = _first;				_first = node;			}			else			{				_first = _last = node;			}						if (l > 1)			{				for (var i:int = l - 2; i >= 0; i--)				{					node = new Node(elements[i]);					node.next = _first;					_first = node;				}			}						_size += l;			return true;		}						/**		 * @inheritDoc		 */		override public function insert(index:int, element:*):Boolean		{			if (index >= _size)			{				return append(element);			}			else if (index <= 0)			{				return prepend(element);			}			else			{				var node:Node = new Node(element);				var current:Node = _first;				var prev:Node;				var i:int = 0;								while (i < index)				{					prev = current;					current = current.next;					i++;				}								prev.next = node;				node.next = current;				_size++;								return true;			}		}						/**		 * @inheritDoc		 */		override public function replace(index:int, element:*):*		{			if (_size < 1) return null;						if (index < 0 || index >= _size)			{				return throwIndexOutOfBoundsException(index);			}			else			{				var node:Node = new Node(element);				var current:Node = _first;				var prev:Node;				var i:int = 0;								/* Replace first */				if (index == 0)				{					node.next = _first.next;					_first = node;				}				/* Replace last */				else if (index == _size - 1)				{					while (i < _size - 2)					{						current = current.next;						prev = current;						i++;					}					current = _last;					node.next = null;					_last = node;					prev.next = _last;				}				/* Replace somewhere between first and last */				else				{					while (i < index)					{						prev = current;						current = current.next;						i++;					}										prev.next = node;					node.next = current.next;				}								return current.data;			}		}						/**		 * @inheritDoc		 */		override public function remove(element:*):*		{			if (_size < 1) return null;						if (element === _first.data)			{				return removeFirst();			}			else if (element === _last.data)			{				return removeLast();			}						var node:Node = _first;			var i:int = 0;						while (i < _size - 2)			{				i++;				node = node.next;				if (node.data === element)				{					return removeAt(i);				}			}						return null;		}						/**		 * @inheritDoc		 */		override public function removeAt(index:int):*		{			if (_size < 1) return null;						if (index < 0 || index >= _size)			{				return throwIndexOutOfBoundsException(index);			}			else if (index == 0)			{				return removeFirst();			}			else if (index == _size - 1)			{				return removeLast();			}			else			{				var current:Node = _first;				var prev:Node;				var i:int = 0;								while (i < index)				{					prev = current;					current = current.next;					i++;				}								var node:Node = current;				prev.next = current.next;				_size--;				return node.data;			}		}						/**		 * @inheritDoc		 */		public function removeFirst():*		{			if (_size < 1) return null;						var node:Node = _first;			if (_first.next == null)			{				_last = null;			}			_first = _first.next;			_size--;			return node.data;		}						/**		 * @inheritDoc		 */		public function removeLast():*		{			if (_size < 1) return null;						var node:Node = _last;			if (_first.next == null)			{				_first = null;			}			else			{				var prev:Node = _first;				while (prev.next != _last)				{					prev = prev.next;				}								_last = prev;				prev.next = null;			}						_size--;			return node.data;		}						//-----------------------------------------------------------------------------------------		// Bulk Operations		//-----------------------------------------------------------------------------------------				/**		 * @inheritDoc		 */		public function clear():void		{			var node:Node = _first;			_first = null;						var next:Node;			while (node)			{				next = node.next;				node.next = null;				node = next;			}			_size = 0;		}	}}// ------------------------------------------------------------------------------------------------/** * Node Class for SinglyLinkedList * @private */final class Node{	public var data:*;	public var next:Node;		/**	 * Constructs a new Node instance for the SinglyLinkedList.	 * @param d the content data for the Node object.	 */	public function Node(d:*)	{		data = d;		next = null;	}}