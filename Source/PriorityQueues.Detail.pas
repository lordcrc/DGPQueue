unit PriorityQueues.Detail;

interface

// based on https://github.com/BlueRaja/High-Speed-Priority-Queue-for-C-Sharp/

uses
  System.SysUtils, Generics.Defaults, Generics.Collections;

type
  IPriorityQueue<E> = interface;

  PriorityQueueEnumerator<E> = record
  strict private
    FImpl: IPriorityQueue<E>;
    FIndex: NativeInt;

    function GetCurrent: E;
  public
    class function Create(const Impl: IPriorityQueue<E>): PriorityQueueEnumerator<E>; static;
    function MoveNext: boolean;
    property Current: E read GetCurrent;
  end;

  PriorityQueueEnumerable<E> = record
  strict private
    FImpl: IPriorityQueue<E>;
  public
    class function Create(const Impl: IPriorityQueue<E>): PriorityQueueEnumerable<E>; static;
    function GetEnumerator(): PriorityQueueEnumerator<E>;
    function ToArray(): TArray<E>;
  end;

  PriorityQueueDequeueEnumerator<E> = record
  strict private
    FImpl: IPriorityQueue<E>;
    FCurrent: E;
  public
    class function Create(const Impl: IPriorityQueue<E>): PriorityQueueDequeueEnumerator<E>; static;
    function MoveNext: boolean;
    property Current: E read FCurrent;
  end;

  PriorityQueueDequeueEnumerable<E> = record
  strict private
    FImpl: IPriorityQueue<E>;
  public
    class function Create(const Impl: IPriorityQueue<E>): PriorityQueueDequeueEnumerable<E>; static;
    function GetEnumerator(): PriorityQueueDequeueEnumerator<E>;
    function ToArray(): TArray<E>;
  end;

  ElementUpdateFunc<E> = reference to procedure(var Element: E);

  IPriorityQueue<E> = interface
    function GetElement(const Index: NativeInt): E;
    function GetCount: NativeInt;

    procedure Enqueue(const Element: E);

    function Dequeue(): E;

    procedure Clear();

    function Contains(const Element: E): boolean;

    procedure Remove(const Element: E);

    procedure UpdateElement(const Element: E; const UpdateFunc: ElementUpdateFunc<E>);

    function ElementIndex(const Element: E): NativeInt;

    property Element[const Index: NativeInt]: E read GetElement; default;
    property Count: NativeInt read GetCount;
  end;

  PriorityQueueImpl<E> = class(TInterfacedObject, IPriorityQueue<E>)
  private
    type
      PQNode = record
        Element: E;
        InsertionIndex: UInt64;
      end;
  strict private
    FHeap: TArray<PQNode>; // heap index is one-based
    FCount: NativeInt;
    FInsertionCounter: UInt64;
    FElementComparer: IComparer<E>;
    FPriorityComparer: IComparer<E>;

    procedure EnsureCapacity;
    procedure Resize(const NewCapacity: NativeInt);

    function HasNodeHigherPriority(const NodeIndex1, NodeIndex2: NativeInt): boolean;

    procedure RemoveNode(const NodeIndex: NativeInt);

    procedure CascadeUp(const NodeIndex: NativeInt);
    procedure CascadeDown(const NodeIndex: NativeInt);

    procedure NodeUpdated(const NodeIndex: NativeInt);

    procedure SwapNodes(const NodeIndex1, NodeIndex2: NativeInt);

    function GetNextInsertionIndex(): UInt64;

    function GetCapacity: NativeInt;

    procedure VerifyIsValidHeap;
  protected
    property Heap: TArray<PQNode> read FHeap;
    property ElementComparer: IComparer<E> read FElementComparer;
    property PriorityComparer: IComparer<E> read FPriorityComparer;
  public
    constructor Create(const ElementComparer: IComparer<E>; const PriorityComparer: IComparer<E>);

    function GetElement(const Index: NativeInt): E;
    function GetCount: NativeInt;

    procedure Enqueue(const Element: E);

    function Dequeue(): E;

    procedure Clear();

    function Contains(const Element: E): boolean;

    procedure Remove(const Element: E);

    procedure UpdateElement(const Element: E; const UpdateFunc: ElementUpdateFunc<E>);

    function ElementIndex(const Element: E): NativeInt;

    property Capacity: NativeInt read GetCapacity;
    property Count: NativeInt read FCount;
  end;


  IPriorityQueue<P, E> = interface;

  PriorityQueueEnumerator<P, E> = record
  strict private
    FImpl: IPriorityQueue<P, E>;
    FIndex: NativeInt;

    function GetCurrent: E;
  public
    class function Create(const Impl: IPriorityQueue<P, E>): PriorityQueueEnumerator<P, E>; static;
    function MoveNext: boolean;
    property Current: E read GetCurrent;
  end;

  PriorityQueueEnumerable<P, E> = record
  strict private
    FImpl: IPriorityQueue<P, E>;
  public
    class function Create(const Impl: IPriorityQueue<P, E>): PriorityQueueEnumerable<P, E>; static;
    function GetEnumerator(): PriorityQueueEnumerator<P, E>;
    function ToArray(): TArray<E>;
  end;

  PriorityQueueDequeueEnumerator<P, E> = record
  strict private
    FImpl: IPriorityQueue<P, E>;
    FCurrent: E;
  public
    class function Create(const Impl: IPriorityQueue<P, E>): PriorityQueueDequeueEnumerator<P, E>; static;
    function MoveNext: boolean;
    property Current: E read FCurrent;
  end;

  PriorityQueueDequeueEnumerable<P, E> = record
  strict private
    FImpl: IPriorityQueue<P, E>;
  public
    class function Create(const Impl: IPriorityQueue<P, E>): PriorityQueueDequeueEnumerable<P, E>; static;
    function GetEnumerator(): PriorityQueueDequeueEnumerator<P, E>;
    function ToArray(): TArray<E>;
  end;

  ElementUpdateFunc<P, E> = reference to procedure(var Priority: P; var Element: E);

  IPriorityQueue<P, E> = interface
    function GetElement(const Index: NativeInt): E;
    function GetCount: NativeInt;

    procedure Enqueue(const Priority: P; const Element: E);

    function Dequeue(): E;

    procedure Clear();

    function Contains(const Element: E): boolean;

    procedure Remove(const Element: E);

    procedure UpdateElement(const Element: E; const UpdateFunc: ElementUpdateFunc<P, E>);

    function ElementIndex(const Element: E): NativeInt;

    property Element[const Index: NativeInt]: E read GetElement; default;
    property Count: NativeInt read GetCount;
  end;

  PriorityQueueImpl<P, E> = class(TInterfacedObject, IPriorityQueue<P, E>)
  private type
    ElmComparerImpl = class(TInterfacedObject, IComparer<TPair<P, E>>)
    strict private
      FElementComparer: IComparer<E>;
    public
      constructor Create(const ElementComparer: IComparer<E>);

      function Compare(const Left, Right: TPair<P, E>): Integer;
    end;

    PriComparerImpl = class(TInterfacedObject, IComparer<TPair<P, E>>)
    strict private
      FPriorityComparer: IComparer<P>;
    public
      constructor Create(const PriorityComparer: IComparer<P>);

      function Compare(const Left, Right: TPair<P, E>): Integer;
    end;
  strict private
    FPriQueue: IPriorityQueue<TPair<P, E>>;
  protected
    property PriQueue: IPriorityQueue<TPair<P, E>> read FPriQueue;
  public
    constructor Create(const ElementComparer: IComparer<E>; const PriorityComparer: IComparer<P>);

    function GetElement(const Index: NativeInt): E;
    function GetCount: NativeInt;

    procedure Enqueue(const Priority: P; const Element: E);

    function Dequeue(): E;

    procedure Clear();

    function Contains(const Element: E): boolean;

    procedure Remove(const Element: E);

    procedure UpdateElement(const Element: E; const UpdateFunc: ElementUpdateFunc<P, E>);

    function ElementIndex(const Element: E): NativeInt;
  end;

implementation

uses
  System.Math;

{ PriorityQueueEnumerator<E> }

class function PriorityQueueEnumerator<E>.Create(
  const Impl: IPriorityQueue<E>): PriorityQueueEnumerator<E>;
begin
  result.FImpl := Impl;
  result.FIndex := -1;
end;

function PriorityQueueEnumerator<E>.GetCurrent: E;
begin
  result := FImpl[FIndex];
end;

function PriorityQueueEnumerator<E>.MoveNext: boolean;
var
  nextIndex: NativeInt;
begin
  nextIndex := FIndex + 1;
  result := (nextIndex > FIndex) and (nextIndex < FImpl.Count);

  if (not result) then
    exit;

  FIndex := nextIndex;
end;

{ PriorityQueueEnumerable<E> }

class function PriorityQueueEnumerable<E>.Create(
  const Impl: IPriorityQueue<E>): PriorityQueueEnumerable<E>;
begin
  result.FImpl := Impl;
end;

function PriorityQueueEnumerable<E>.GetEnumerator: PriorityQueueEnumerator<E>;
begin
  result := PriorityQueueEnumerator<E>.Create(FImpl);
end;

function PriorityQueueEnumerable<E>.ToArray: TArray<E>;
var
  i: NativeInt;
begin
  SetLength(result, FImpl.Count);
  for i := 0 to FImpl.Count-1 do
  begin
    result[i] := FImpl[i];
  end;
end;

{ PriorityQueueDequeueEnumerator<E> }

class function PriorityQueueDequeueEnumerator<E>.Create(
  const Impl: IPriorityQueue<E>): PriorityQueueDequeueEnumerator<E>;
begin
  result.FImpl := Impl;
end;

function PriorityQueueDequeueEnumerator<E>.MoveNext: boolean;
begin
  result := (FImpl.Count > 0);
  if (not result) then
    exit;

  FCurrent := FImpl.Dequeue();
end;

{ PriorityQueueDequeueEnumerable<E> }

class function PriorityQueueDequeueEnumerable<E>.Create(
  const Impl: IPriorityQueue<E>): PriorityQueueDequeueEnumerable<E>;
begin
  result.FImpl := Impl;
end;

function PriorityQueueDequeueEnumerable<E>.GetEnumerator: PriorityQueueDequeueEnumerator<E>;
begin
  result := PriorityQueueDequeueEnumerator<E>.Create(FImpl);
end;

function PriorityQueueDequeueEnumerable<E>.ToArray: TArray<E>;
var
  i: NativeInt;
begin
  SetLength(result, FImpl.Count);
  for i := 0 to FImpl.Count-1 do
  begin
    result[i] := FImpl.Dequeue();
  end;
end;

{ PriorityQueueImpl<E> }

procedure PriorityQueueImpl<E>.CascadeDown(const NodeIndex: NativeInt);
var
  curNodeIndex: NativeInt;
  leftChildNodeIndex: NativeInt;
  rightChildNodeIndex: NativeInt;
  childHasHigherPriority: boolean;
  newParentNodeIndex: NativeInt;
begin
  curNodeIndex := NodeIndex;

  while (True) do
  begin
    newParentNodeIndex := curNodeIndex;
    leftChildNodeIndex := 2 * curNodeIndex;
    rightChildNodeIndex := 2 * curNodeIndex + 1;

    // Check if the left-child is higher-priority than the current node
    if (leftChildNodeIndex > Count) then
    begin
      exit;
    end;

    childHasHigherPriority := HasNodeHigherPriority(leftChildNodeIndex, newParentNodeIndex);
    if (childHasHigherPriority) then
    begin
      newParentNodeIndex := leftChildNodeIndex;
    end;

    // Check if the right-child is higher-priority than either the current node or the left child
    if (rightChildNodeIndex <= Count) then
    begin
      childHasHigherPriority := HasNodeHigherPriority(rightChildNodeIndex, newParentNodeIndex);
      if (childHasHigherPriority) then
      begin
        newParentNodeIndex := rightChildNodeIndex;
      end;
    end;

    if (newParentNodeIndex = curNodeIndex) then
    begin
      // neither child has higher priority, so stop
      exit;
    end;

    // Either of the children has higher (smaller) priority
    // swap and continue cascading
    SwapNodes(curNodeIndex, newParentNodeIndex);
    curNodeIndex := newParentNodeIndex;
  end;
end;

procedure PriorityQueueImpl<E>.CascadeUp(const NodeIndex: NativeInt);
var
  curNodeIndex: NativeInt;
  parentNodeIndex: NativeInt;
  parentHasHigherPriority: boolean;
begin
  curNodeIndex := NodeIndex;
  parentNodeIndex := NodeIndex shr 1;

  while (parentNodeIndex > 0) do
  begin
    parentHasHigherPriority := HasNodeHigherPriority(parentNodeIndex, curNodeIndex);

    if (parentHasHigherPriority) then
      exit;

    // node has higher priority so move it up the heap
    SwapNodes(curNodeIndex, parentNodeIndex);

    // and walk up the heap
    curNodeIndex := parentNodeIndex;
    parentNodeIndex := parentNodeIndex shr 1;
  end;
end;

procedure PriorityQueueImpl<E>.Clear;
begin
  FHeap := nil;
  FCount := 0;
end;

function PriorityQueueImpl<E>.Contains(const Element: E): boolean;
var
  i: integer;
  cmp: integer;
begin
  result := True;
  for i := 1 to Count do
  begin
    cmp := ElementComparer.Compare(Heap[i].Element, Element);
    if (cmp = 0) then
      exit;
  end;
  result := False;
end;

constructor PriorityQueueImpl<E>.Create(
  const ElementComparer: IComparer<E>;
  const PriorityComparer: IComparer<E>);
begin
  inherited Create;

  FElementComparer := ElementComparer;
  FPriorityComparer := PriorityComparer;
end;

function PriorityQueueImpl<E>.Dequeue: E;
begin
  result := Heap[1].Element;
  RemoveNode(1);
end;

function PriorityQueueImpl<E>.ElementIndex(const Element: E): NativeInt;
var
  i: NativeInt;
  cmp: integer;
begin
  result := -1;

  for i := 1 to Count do
  begin
    cmp := ElementComparer.Compare(Heap[i].Element, Element);
    if (cmp = 0) then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure PriorityQueueImpl<E>.Enqueue(const Element: E);
var
  nodeIndex: integer;
begin
  VerifyIsValidHeap();

  EnsureCapacity();

  FCount := FCount + 1;
  nodeIndex := FCount;

  FHeap[nodeIndex].Element := Element;
  FHeap[nodeIndex].InsertionIndex := GetNextInsertionIndex();

  CascadeUp(nodeIndex);

  VerifyIsValidHeap();
end;

procedure PriorityQueueImpl<E>.EnsureCapacity;
var
  curCapacity: NativeInt;
  requiredCapacity: NativeInt;
  newCapacity: NativeInt;
begin
  curCapacity := Capacity;
  requiredCapacity := Count + 1;

  if (curCapacity > requiredCapacity) then
    exit;

  newCapacity := Max(requiredCapacity + 1, requiredCapacity + requiredCapacity shr 1);

  // overflow
  if (newCapacity < 0) then
    raise EInvalidOpException.Create('PriorityQueueImpl.EnsureCapacity: heap full');

  Resize(newCapacity);
end;

function PriorityQueueImpl<E>.GetCapacity: NativeInt;
begin
  result := Length(Heap) - 1; // one-based indexing
end;

function PriorityQueueImpl<E>.GetCount: NativeInt;
begin
  result := FCount;
end;

function PriorityQueueImpl<E>.GetElement(const Index: NativeInt): E;
begin
  if ((Index < 0) or (Index >= Count)) then
    raise EArgumentOutOfRangeException.CreateFmt('PriorityQueueImpl.GetElement: invalid element index %d', [Index]);

  result := Heap[Index+1].Element;
end;

function PriorityQueueImpl<E>.GetNextInsertionIndex: UInt64;
begin
  FInsertionCounter := FInsertionCounter + 1;

  if (FInsertionCounter = High(UInt64)) then
    raise EInvalidOpException.Create('PriorityQueueImpl: insertion counter overflow');

  result := FInsertionCounter;
end;

function PriorityQueueImpl<E>.HasNodeHigherPriority(const NodeIndex1,
  NodeIndex2: NativeInt): boolean;
var
  cmp: integer;
begin
  cmp := PriorityComparer.Compare(Heap[NodeIndex1].Element, Heap[NodeIndex2].Element);

  result := (cmp < 0);
  if (result) then
    exit;

  // if equal priority, use insertion index to break tie
  result := (cmp = 0) and (FHeap[NodeIndex1].InsertionIndex < FHeap[NodeIndex2].InsertionIndex);
end;

procedure PriorityQueueImpl<E>.NodeUpdated(const NodeIndex: NativeInt);
var
  parentNodeIndex: NativeInt;
  cascadeNodeUp: boolean;
begin
  parentNodeIndex := NodeIndex shr 1;

  // if node is root, cascade down
  cascadeNodeUp := (parentNodeIndex > 0);
  if (cascadeNodeUp) then
    cascadeNodeUp := HasNodeHigherPriority(NodeIndex, parentNodeIndex);

  if (cascadeNodeUp) then
    CascadeUp(NodeIndex)
  else
    CascadeDown(NodeIndex);
end;

procedure PriorityQueueImpl<E>.Remove(const Element: E);
var
  nodeIndex: NativeInt;
  hasNode: boolean;
begin
  nodeIndex := ElementIndex(Element);

  hasNode := (nodeIndex > 0);
  if (not hasNode) then
    exit;

  RemoveNode(nodeIndex);
end;

procedure PriorityQueueImpl<E>.RemoveNode(const NodeIndex: NativeInt);
var
  isLastNode: boolean;
  lastNodeIndex: NativeInt;
begin
  VerifyIsValidHeap();

  lastNodeIndex := Count;
//  isLastNode := (FHeap[NodeIndex].QueueIndex = lastNodeIndex);
  isLastNode := (NodeIndex = lastNodeIndex);

  // last node can be removed without fuzz
  if (isLastNode) then
  begin
    FHeap[NodeIndex] := Default(PQNode);
    FCount := FCount - 1;

    VerifyIsValidHeap();

    exit;
  end;

  // swap node with last node
  // and delete it
  SwapNodes(NodeIndex, lastNodeIndex);
  FHeap[lastNodeIndex] := Default(PQNode);
  FCount := FCount - 1;

  NodeUpdated(NodeIndex);

  VerifyIsValidHeap();
end;

procedure PriorityQueueImpl<E>.Resize(const NewCapacity: NativeInt);
begin
  if (NewCapacity < Count) then
    raise EArgumentException.CreateFmt('PriorityQueueImpl.Resize: requested capacity %d is less than count %d', [NewCapacity, Count]);

  SetLength(FHeap, NewCapacity + 1); // one-based indexing
end;

procedure PriorityQueueImpl<E>.SwapNodes(const NodeIndex1, NodeIndex2: NativeInt);
var
  tnode: PQNode;
begin
  tnode := FHeap[NodeIndex1];

  FHeap[NodeIndex1] := FHeap[NodeIndex2];
//  FHeap[NodeIndex1].QueueIndex := NodeIndex1;

  FHeap[NodeIndex2] := tnode;
//  FHeap[NodeIndex2].QueueIndex := NodeIndex2;
end;

procedure PriorityQueueImpl<E>.UpdateElement(const Element: E; const UpdateFunc: ElementUpdateFunc<E>);
var
  nodeIndex: NativeInt;
begin
  nodeIndex := ElementIndex(Element);

  if (nodeIndex <= 0) then
    raise EArgumentException.Create('PriorityQueueImpl.UpdatePriority: element not found');

  UpdateFunc(FHeap[nodeIndex]);

  NodeUpdated(nodeIndex);
end;

procedure PriorityQueueImpl<E>.VerifyIsValidHeap;
{$IFDEF DEBUG_PRIORITYQUEUE}
var
  i: NativeInt;
  leftChildIndex: NativeInt;
  rightChildIndex: NativeInt;
begin
  for i := 1 to Count do
  begin
    leftChildIndex := i * 2;
    if ((leftChildIndex < Length(Heap)) and (Heap[leftChildIndex].InsertionIndex <> 0) and (HasNodeHigherPriority(leftChildIndex, i))) then
      raise EProgrammerNotFound.Create('Invalid heap');

    rightChildIndex := i * 2 + 1;
    if ((rightChildIndex < Length(Heap)) and (Heap[rightChildIndex].InsertionIndex <> 0) and (HasNodeHigherPriority(rightChildIndex, i))) then
      raise EProgrammerNotFound.Create('Invalid heap');
  end;

  for i := Count+1 to High(Heap) do
  begin
    if (Heap[i].InsertionIndex <> 0) then
      raise EProgrammerNotFound.Create('Corrupt heap');
  end;
end;
{$ELSE}
begin
end;
{$ENDIF}

{ PriorityQueueEnumerator<P, E> }

class function PriorityQueueEnumerator<P, E>.Create(
  const Impl: IPriorityQueue<P, E>): PriorityQueueEnumerator<P, E>;
begin
  result.FImpl := Impl;
  result.FIndex := -1;
end;

function PriorityQueueEnumerator<P, E>.GetCurrent: E;
begin
  result := FImpl[FIndex];
end;

function PriorityQueueEnumerator<P, E>.MoveNext: boolean;
var
  nextIndex: NativeInt;
begin
  nextIndex := FIndex + 1;
  result := (nextIndex > FIndex) and (nextIndex < FImpl.Count);

  if (not result) then
    exit;

  FIndex := nextIndex;
end;

{ PriorityQueueEnumerable<P, E> }

class function PriorityQueueEnumerable<P, E>.Create(
  const Impl: IPriorityQueue<P, E>): PriorityQueueEnumerable<P, E>;
begin
  result.FImpl := Impl;
end;

function PriorityQueueEnumerable<P, E>.GetEnumerator: PriorityQueueEnumerator<P, E>;
begin
  result := PriorityQueueEnumerator<P, E>.Create(FImpl);
end;

function PriorityQueueEnumerable<P, E>.ToArray: TArray<E>;
var
  i: NativeInt;
begin
  SetLength(result, FImpl.Count);
  for i := 0 to FImpl.Count-1 do
  begin
    result[i] := FImpl[i];
  end;
end;

{ PriorityQueueDequeueEnumerator<P, E> }

class function PriorityQueueDequeueEnumerator<P, E>.Create(
  const Impl: IPriorityQueue<P, E>): PriorityQueueDequeueEnumerator<P, E>;
begin
  result.FImpl := Impl;
end;

function PriorityQueueDequeueEnumerator<P, E>.MoveNext: boolean;
begin
  result := (FImpl.Count > 0);
  if (not result) then
    exit;

  FCurrent := FImpl.Dequeue();
end;

{ PriorityQueueDequeueEnumerable<P, E> }

class function PriorityQueueDequeueEnumerable<P, E>.Create(
  const Impl: IPriorityQueue<P, E>): PriorityQueueDequeueEnumerable<P, E>;
begin
  result.FImpl := Impl;
end;

function PriorityQueueDequeueEnumerable<P, E>.GetEnumerator: PriorityQueueDequeueEnumerator<P, E>;
begin
  result := PriorityQueueDequeueEnumerator<P, E>.Create(FImpl);
end;

function PriorityQueueDequeueEnumerable<P, E>.ToArray: TArray<E>;
var
  i: NativeInt;
begin
  SetLength(result, FImpl.Count);
  for i := 0 to FImpl.Count-1 do
  begin
    result[i] := FImpl.Dequeue();
  end;
end;

{ PriorityQueueImpl<P, E> }

procedure PriorityQueueImpl<P, E>.Clear;
begin
  PriQueue.Clear;
end;

function PriorityQueueImpl<P, E>.Contains(const Element: E): boolean;
begin
  result := PriQueue.Contains(TPair<P, E>.Create(Default(P), Element));
end;

constructor PriorityQueueImpl<P, E>.Create(const ElementComparer: IComparer<E>;
  const PriorityComparer: IComparer<P>);
var
  elmComparer: IComparer<TPair<P, E>>;
  priComparer: IComparer<TPair<P, E>>;
begin
  inherited Create;

  elmComparer := ElmComparerImpl.Create(ElementComparer);
  priComparer := PriComparerImpl.Create(PriorityComparer);

  FPriQueue := PriorityQueueImpl<TPair<P, E>>.Create(elmComparer, priComparer);
end;

function PriorityQueueImpl<P, E>.Dequeue: E;
begin
  result := PriQueue.Dequeue().Value;
end;

function PriorityQueueImpl<P, E>.ElementIndex(const Element: E): NativeInt;
begin
  result := PriQueue.ElementIndex(TPair<P, E>.Create(Default(P), Element));
end;

procedure PriorityQueueImpl<P, E>.Enqueue(const Priority: P; const Element: E);
begin
  PriQueue.Enqueue(TPair<P, E>.Create(Priority, Element));
end;

function PriorityQueueImpl<P, E>.GetCount: NativeInt;
begin
  result := PriQueue.Count;
end;

function PriorityQueueImpl<P, E>.GetElement(const Index: NativeInt): E;
begin
  result := PriQueue.Element[Index].Value;
end;

procedure PriorityQueueImpl<P, E>.Remove(const Element: E);
begin
  PriQueue.Remove(TPair<P, E>.Create(Default(P), Element));
end;

procedure PriorityQueueImpl<P, E>.UpdateElement(const Element: E;
  const UpdateFunc: ElementUpdateFunc<P, E>);
begin
  PriQueue.UpdateElement(
    TPair<P, E>.Create(Default(P), Element),
    procedure(var Elm: TPair<P, E>)
    begin
      UpdateFunc(Elm.Key, Elm.Value);
    end
  );
end;

{ PriorityQueueImpl<P, E>.ElmComparerImpl }

function PriorityQueueImpl<P, E>.ElmComparerImpl.Compare(const Left,
  Right: TPair<P, E>): Integer;
begin
  result := FElementComparer.Compare(Left.Value, Right.Value);
end;

constructor PriorityQueueImpl<P, E>.ElmComparerImpl.Create(
  const ElementComparer: IComparer<E>);
begin
  inherited Create;

  FElementComparer := ElementComparer;
end;

{ PriorityQueueImpl<P, E>.PriComparerImpl }

function PriorityQueueImpl<P, E>.PriComparerImpl.Compare(const Left,
  Right: TPair<P, E>): Integer;
begin
  result := FPriorityComparer.Compare(Left.Key, Right.Key);
end;

constructor PriorityQueueImpl<P, E>.PriComparerImpl.Create(
  const PriorityComparer: IComparer<P>);
begin
  inherited Create;

  FPriorityComparer := PriorityComparer;
end;

end.
