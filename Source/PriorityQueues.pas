unit PriorityQueues;

interface

uses
  System.SysUtils, Generics.Defaults, Generics.Collections, PriorityQueues.Detail;

type
  PriorityQueue<E> = record
  {$REGION 'Implementation details'}
  strict private
    FImpl: IPriorityQueue<E>;

    function GetFirst: E;
    function GetCount: NativeInt;
  private
    property Impl: IPriorityQueue<E> read FImpl;
  {$ENDREGION}
  public
    class function Create(): PriorityQueue<E>; overload; static;
    class function Create(const ElementComparer: IComparer<E>): PriorityQueue<E>; overload; static;
    class function Create(const ElementComparer: IComparer<E>; const PriorityComparer: IComparer<E>): PriorityQueue<E>; overload; static;

    class operator Implicit(const Impl: IPriorityQueue<E>): PriorityQueue<E>;

    class operator In(const Element: E; const PriQueue: PriorityQueue<E>): boolean;

    procedure Enqueue(const Element: E);

    function Dequeue(): E;

    procedure Clear();

    function Contains(const Element: E): boolean;

    procedure Remove(const Element: E);

    function GetEnumerator(): PriorityQueueEnumerator<E>;

    function Elements(): PriorityQueueEnumerable<E>;
    function DequedElements(): PriorityQueueDequeueEnumerable<E>;

    property First: E read GetFirst;
    property Count: NativeInt read GetCount;
  end;

  PriorityQueue<P, E> = record
  {$REGION 'Implementation details'}
  strict private
    FImpl: IPriorityQueue<P, E>;

    function GetFirst: E;
    function GetCount: NativeInt;
  private
    property Impl: IPriorityQueue<P, E> read FImpl;
  {$ENDREGION}
  public
    class function Create(): PriorityQueue<P, E>; overload; static;
    class function Create(const PriorityComparer: IComparer<P>): PriorityQueue<P, E>; overload; static;
    class function Create(const ElementComparer: IComparer<E>): PriorityQueue<P, E>; overload; static;
    class function Create(const ElementComparer: IComparer<E>; const PriorityComparer: IComparer<P>): PriorityQueue<P, E>; overload; static;

    class operator Implicit(const Impl: IPriorityQueue<P, E>): PriorityQueue<P, E>;

    class operator In(const Element: E; const PriQueue: PriorityQueue<P, E>): boolean;

    procedure Enqueue(const Priority: P; const Element: E);

    function Dequeue(): E;

    procedure Clear();

    function Contains(const Element: E): boolean;

    procedure Remove(const Element: E);

    procedure UpdatePriority(const Element: E; const NewPriority: P);

    function GetEnumerator(): PriorityQueueEnumerator<P, E>;

    function Elements(): PriorityQueueEnumerable<P, E>;
    function DequedElements(): PriorityQueueDequeueEnumerable<P, E>;

    property First: E read GetFirst;
    property Count: NativeInt read GetCount;
  end;

  PriorityDerivationFunc<P, E> = reference to function(const Element: E): P;

  DerivedPriorityQueue<P, E> = record
  {$REGION 'Implementation details'}
  strict private
    FImpl: IPriorityQueue<P, E>;
    FPriorityFunc: PriorityDerivationFunc<P, E>;

    function GetFirst: E;
    function GetCount: NativeInt;
  private
    property Impl: IPriorityQueue<P, E> read FImpl;
    property PriorityFunc: PriorityDerivationFunc<P, E> read FPriorityFunc;
  {$ENDREGION}
  public
    class function Create(const PriorityFunc: PriorityDerivationFunc<P, E>): DerivedPriorityQueue<P, E>; overload; static;
    class function Create(const ElementComparer: IComparer<E>; const PriorityFunc: PriorityDerivationFunc<P, E>): DerivedPriorityQueue<P, E>; overload; static;

    class operator Implicit(const Impl: IPriorityQueue<P, E>): DerivedPriorityQueue<P, E>;

    class operator Explicit(const DerviedPriQueue: DerivedPriorityQueue<P, E>): PriorityQueue<P, E>;

    class operator In(const Element: E; const PriQueue: DerivedPriorityQueue<P, E>): boolean;

    procedure Enqueue(const Element: E);

    function Dequeue(): E;

    procedure Clear();

    function Contains(const Element: E): boolean;

    procedure Remove(const Element: E);

    function GetEnumerator: PriorityQueueEnumerator<P, E>;

    function Elements(): PriorityQueueEnumerable<P, E>;
    function DequedElements(): PriorityQueueDequeueEnumerable<P, E>;

    property First: E read GetFirst;
    property Count: NativeInt read GetCount;
  end;

implementation

{ PriorityQueue<E> }

procedure PriorityQueue<E>.Clear;
begin
  Impl.Clear;
end;

function PriorityQueue<E>.Contains(const Element: E): boolean;
begin
  result := Impl.Contains(Element);
end;

class function PriorityQueue<E>.Create(const ElementComparer,
  PriorityComparer: IComparer<E>): PriorityQueue<E>;
begin
  result.FImpl := PriorityQueueImpl<E>.Create(ElementComparer, PriorityComparer);
end;

class function PriorityQueue<E>.Create: PriorityQueue<E>;
begin
  result := Create(TComparer<E>.Default, TComparer<E>.Default);
end;

class function PriorityQueue<E>.Create(
  const ElementComparer: IComparer<E>): PriorityQueue<E>;
begin
  result := Create(ElementComparer, TComparer<E>.Default);
end;

function PriorityQueue<E>.DequedElements: PriorityQueueDequeueEnumerable<E>;
begin
  result := PriorityQueueDequeueEnumerable<E>.Create(Impl);
end;

function PriorityQueue<E>.Dequeue: E;
begin
  result := Impl.Dequeue();
end;

function PriorityQueue<E>.Elements: PriorityQueueEnumerable<E>;
begin
  result := PriorityQueueEnumerable<E>.Create(Impl);
end;

procedure PriorityQueue<E>.Enqueue(const Element: E);
begin
  Impl.Enqueue(Element);
end;

function PriorityQueue<E>.GetCount: NativeInt;
begin
  result := Impl.Count;
end;

function PriorityQueue<E>.GetEnumerator: PriorityQueueEnumerator<E>;
begin
  result := PriorityQueueEnumerator<E>.Create(Impl);
end;

function PriorityQueue<E>.GetFirst: E;
begin
  result := Impl.Element[0];
end;

class operator PriorityQueue<E>.Implicit(
  const Impl: IPriorityQueue<E>): PriorityQueue<E>;
begin
  result.FImpl := Impl;
end;

class operator PriorityQueue<E>.In(const Element: E;
  const PriQueue: PriorityQueue<E>): boolean;
begin
  result := PriQueue.Contains(Element);
end;

procedure PriorityQueue<E>.Remove(const Element: E);
begin
  Impl.Remove(Element);
end;

{ PriorityQueue<P, E> }

procedure PriorityQueue<P, E>.UpdatePriority(const Element: E;
  const NewPriority: P);
begin
  Impl.UpdateElement(Element,
    procedure(var Priority: P; var Element: E)
    begin
      Priority := NewPriority;
    end
  );
end;

procedure PriorityQueue<P, E>.Clear;
begin
  Impl.Clear();
end;

function PriorityQueue<P, E>.Contains(const Element: E): boolean;
begin
  result := Impl.Contains(Element);
end;

class function PriorityQueue<P, E>.Create(
  const ElementComparer: IComparer<E>): PriorityQueue<P, E>;
begin
  result := Create(ElementComparer, TComparer<P>.Default);
end;

class function PriorityQueue<P, E>.Create(const ElementComparer: IComparer<E>;
  const PriorityComparer: IComparer<P>): PriorityQueue<P, E>;
begin
  result := PriorityQueueImpl<P, E>.Create(ElementComparer, PriorityComparer);
end;

class function PriorityQueue<P, E>.Create(
  const PriorityComparer: IComparer<P>): PriorityQueue<P, E>;
begin
  result := Create(TComparer<E>.Default, PriorityComparer);
end;

class function PriorityQueue<P, E>.Create: PriorityQueue<P, E>;
begin
  result := Create(TComparer<E>.Default, TComparer<P>.Default);
end;

function PriorityQueue<P, E>.DequedElements: PriorityQueueDequeueEnumerable<P, E>;
begin
  result := PriorityQueueDequeueEnumerable<P, E>.Create(Impl);
end;

function PriorityQueue<P, E>.Dequeue: E;
begin
  result := Impl.Dequeue();
end;

function PriorityQueue<P, E>.Elements: PriorityQueueEnumerable<P, E>;
begin
  result := PriorityQueueEnumerable<P, E>.Create(Impl);
end;

procedure PriorityQueue<P, E>.Enqueue(const Priority: P; const Element: E);
begin
  Impl.Enqueue(Priority, Element);
end;

function PriorityQueue<P, E>.GetCount: NativeInt;
begin
  result := Impl.Count;
end;

function PriorityQueue<P, E>.GetEnumerator: PriorityQueueEnumerator<P, E>;
begin
  result := PriorityQueueEnumerator<P, E>.Create(Impl);
end;

function PriorityQueue<P, E>.GetFirst: E;
begin
  result := Impl[0];
end;

class operator PriorityQueue<P, E>.Implicit(
  const Impl: IPriorityQueue<P, E>): PriorityQueue<P, E>;
begin
  result.FImpl := Impl;
end;

class operator PriorityQueue<P, E>.In(const Element: E;
  const PriQueue: PriorityQueue<P, E>): boolean;
begin
  result := PriQueue.Contains(Element);
end;

procedure PriorityQueue<P, E>.Remove(const Element: E);
begin
  Impl.Remove(Element);
end;

{ DerivedPriorityQueue<P, E> }

procedure DerivedPriorityQueue<P, E>.Clear;
begin
  Impl.Clear;
end;

function DerivedPriorityQueue<P, E>.Contains(const Element: E): boolean;
begin
  result := Impl.Contains(Element);
end;

class function DerivedPriorityQueue<P, E>.Create(
  const ElementComparer: IComparer<E>;
  const PriorityFunc: PriorityDerivationFunc<P, E>): DerivedPriorityQueue<P, E>;
begin
  result.FImpl := PriorityQueueImpl<P, E>.Create(ElementComparer, TComparer<P>.Default);
  result.FPriorityFunc := PriorityFunc;
end;

class function DerivedPriorityQueue<P, E>.Create(
  const PriorityFunc: PriorityDerivationFunc<P, E>): DerivedPriorityQueue<P, E>;
begin
  result.FImpl := PriorityQueueImpl<P, E>.Create(TComparer<E>.Default, TComparer<P>.Default);
  result.FPriorityFunc := PriorityFunc;
end;

function DerivedPriorityQueue<P, E>.DequedElements: PriorityQueueDequeueEnumerable<P, E>;
begin
  result := PriorityQueueDequeueEnumerable<P, E>.Create(Impl);
end;

function DerivedPriorityQueue<P, E>.Dequeue: E;
begin
  result := Impl.Dequeue();
end;

function DerivedPriorityQueue<P, E>.Elements: PriorityQueueEnumerable<P, E>;
begin
  result := PriorityQueueEnumerable<P, E>.Create(Impl);
end;

procedure DerivedPriorityQueue<P, E>.Enqueue(const Element: E);
begin
  Impl.Enqueue(PriorityFunc(Element), Element);
end;

class operator DerivedPriorityQueue<P, E>.Explicit(
  const DerviedPriQueue: DerivedPriorityQueue<P, E>): PriorityQueue<P, E>;
begin
  result := DerviedPriQueue.Impl;
end;

function DerivedPriorityQueue<P, E>.GetCount: NativeInt;
begin
  result := Impl.Count;
end;

function DerivedPriorityQueue<P, E>.GetEnumerator: PriorityQueueEnumerator<P, E>;
begin
  result := PriorityQueueEnumerator<P, E>.Create(Impl);
end;

function DerivedPriorityQueue<P, E>.GetFirst: E;
begin
  result := Impl[0];
end;

class operator DerivedPriorityQueue<P, E>.Implicit(
  const Impl: IPriorityQueue<P, E>): DerivedPriorityQueue<P, E>;
begin
  result.FImpl := Impl;
end;

class operator DerivedPriorityQueue<P, E>.In(const Element: E;
  const PriQueue: DerivedPriorityQueue<P, E>): boolean;
begin
  result := PriQueue.Contains(Element);
end;

procedure DerivedPriorityQueue<P, E>.Remove(const Element: E);
begin
  Impl.Remove(Element);
end;

end.
