program PriorityQueueDev;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  PriorityQueues.Detail in 'Source\PriorityQueues.Detail.pas',
  PriorityQueues in 'Source\PriorityQueues.pas';

procedure Test1;
var
  pqueue: PriorityQueue<string>;
begin
  pqueue := PriorityQueue<string>.Create();

  pqueue.Enqueue('one');
  pqueue.Enqueue('two');
  pqueue.Enqueue('three');
  pqueue.Enqueue('four');
  pqueue.Enqueue('five');

  WriteLn(pqueue.Dequeue());
  WriteLn(pqueue.Dequeue());
  WriteLn(pqueue.Dequeue());
  WriteLn(pqueue.Dequeue());
  WriteLn(pqueue.Dequeue());

  WriteLn;
  WriteLn;
end;

procedure Test2;
var
  pqueue: PriorityQueue<integer, string>;
begin
  pqueue := PriorityQueue<integer, string>.Create();

  pqueue.Enqueue(1, 'one');
  pqueue.Enqueue(5, 'five');
  pqueue.Enqueue(2, 'two');
  pqueue.Enqueue(4, 'four');
  pqueue.Enqueue(3, 'three');

  pqueue.UpdatePriority('four', 0);

  WriteLn(pqueue.Dequeue());
  WriteLn(pqueue.Dequeue());
  WriteLn(pqueue.Dequeue());
  WriteLn(pqueue.Dequeue());
  WriteLn(pqueue.Dequeue());

  WriteLn;
  WriteLn;
end;

procedure Test3;
var
  pqueue: DerivedPriorityQueue<integer, string>;
  s: string;
begin
  pqueue := DerivedPriorityQueue<integer, string>.Create(
    function(const Element: string): integer
    begin
      result := Length(Element);
    end
  );

  pqueue.Enqueue('one');
  pqueue.Enqueue('five');
  pqueue.Enqueue('two');
  pqueue.Enqueue('four');
  pqueue.Enqueue('three');

  for s in pqueue.DequedElements do
  begin
    WriteLn(s);
  end;

  WriteLn;
  WriteLn;
end;

procedure Run;
begin
  Test1;
  Test2;
  Test3;
end;

begin
  try
    Run;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  WriteLn('done...');
  ReadLn;
end.
