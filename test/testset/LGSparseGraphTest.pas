unit LGSparseGraphTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  LGUtils,
  LGArrayHelpers,
  LGVector,
  LGSparseGraph,
  LGSimpleGraph,
  LGSimpleDigraph;

type

  SparseGraphTest = class(TTestCase)
  private
  type
    TGraph      = TIntChart;
    TDiGraph    = TIntFlowChart;
    TGraphRef   = specialize TGAutoRef<TGraph>;
    TDiGraphRef = specialize TGAutoRef<TDiGraph>;
    THelper     = specialize TGOrdinalArrayHelper<SizeInt>;

  var
    FFound,
    FDone: TBoolVector;
    function  GenerateTestGrBip1: TGraph;
    function  GenerateTestDigrBip1: TDiGraph;
    function  GenerateTestGr1: TGraph;
    function  GenerateTestDigr1: TDiGraph;
    function  vFound({%H-}aSender: TObject; aIndex: SizeInt): Boolean;
    procedure vDone({%H-}aSender: TObject; aIndex: SizeInt);
  published
    procedure IsEmpty;
    procedure IsEmptyDirect;
    procedure NonEmpty;
    procedure NonEmptyDirect;
    procedure EnsureCapacity;
    procedure EnsureCapacityDirect;
    procedure Clear;
    procedure ClearDirect;
    procedure AddVertex;
    procedure AddVertexDirect;
    procedure RemoveVertex;
    procedure RemoveVertexDirect;
    procedure IndexOf;
    procedure IndexOfDirect;
    procedure Items;
    procedure ItemsDirect;
    procedure RemoveVertexI;
    procedure RemoveVertexIDirect;
    procedure ContainsVertex;
    procedure ContainsVertexDirect;
    procedure AddEdge;
    procedure AddArc;
    procedure AddEdgeI;
    procedure AddEdgeIDirect;
    procedure Adjacent;
    procedure AdjacentDirect;
    procedure AdjVertices;
    procedure AdjVerticesDirect;
    procedure AdjVerticesI;
    procedure AdjVerticesIDirect;
    procedure Vertices;
    procedure VerticesDirect;
    procedure IsBipartite;
    procedure IsBipartiteDirect;
    procedure DfsTraversal;
    procedure DfsTraversalDirect;
    procedure BfsTraversal;
    procedure BfsTraversalDirect;
    procedure ShortestPaths;
    procedure ShortestPathsDirect;
    procedure Eccentricity;
    procedure EccentricityDirect;
  end;

  TTspTest = class(TTestCase)
  private
  type
    TSolver = specialize TGMetricTspHelper<Integer>;

    function CreateAsymmMatrix: TSolver.TTspMatrix;
    function CreateSymmMatrix: TSolver.TTspMatrix;
  published
    procedure Asymmetric;
    procedure Symmetric;
  end;

implementation

function SparseGraphTest.GenerateTestGrBip1: TGraph;
begin
  Result := TGraph.Create;
  Result.AddVertexRange(1, 16);
  Result.AddEdges([1, 2, 1, 4, 1, 6, 3, 4, 3, 6, 3, 8, 5, 6, 5, 8, 5, 10, 7, 8, 7, 10, 7,
                   12, 9, 10, 9, 12, 9, 14, 11, 12, 11, 14, 11, 16, 13, 14, 13, 16, 15, 16]);
end;

function SparseGraphTest.GenerateTestDigrBip1: TDiGraph;
begin
  Result := TDiGraph.Create;
  Result.AddVertexRange(1, 12);
  Result.AddEdges([1, 2, 1, 4, 1, 6, 2, 3, 3, 4, 3, 6, 3, 8, 4, 5, 5, 6, 5, 8, 5, 10,
                   6, 7, 7, 8, 7, 10, 7, 12, 8, 9, 9, 10, 9, 12, 10, 11, 11, 8, 12, 1]);
end;

function SparseGraphTest.GenerateTestGr1: TGraph;
begin
  Result := TGraph.Create;
  Result.AddVertexRange(0, 12);
  Result.AddEdges([0, 1, 0, 2, 0, 3, 0, 5, 0, 6, 2, 3, 3, 5, 3, 4, 6, 4, 4, 9, 6, 9, 7, 6,
                   8, 7, 9, 10, 9, 11, 9, 12, 11, 12]);
end;

function SparseGraphTest.GenerateTestDigr1: TDiGraph;
begin
  Result := TDiGraph.Create;
  Result.AddVertexRange(0, 12);
  Result.AddEdges([0, 1, 0, 2, 0, 3, 0, 5, 0, 6, 2, 3, 3, 5, 3, 4, 6, 4, 4, 9, 6, 9, 7, 6,
                   8, 7, 9, 10, 9, 11, 9, 12, 11, 12]);
end;

function SparseGraphTest.vFound(aSender: TObject; aIndex: SizeInt): Boolean;
begin
  FFound[aIndex] := False;
  Result := True;
end;

procedure SparseGraphTest.vDone(aSender: TObject; aIndex: SizeInt);
begin
  FDone[aIndex] := False;
end;

procedure SparseGraphTest.IsEmpty;
var
  Ref: TGraphRef;
  g: TGraph;
begin
  g := {%H-}Ref;
  AssertTrue(g.IsEmpty);
  AssertTrue(g.AddVertex(3));
  AssertFalse(g.IsEmpty);
end;

procedure SparseGraphTest.IsEmptyDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
begin
  g := {%H-}Ref;
  AssertTrue(g.IsEmpty);
  AssertTrue(g.AddVertex(3));
  AssertFalse(g.IsEmpty);
end;

procedure SparseGraphTest.NonEmpty;
var
  Ref: TGraphRef;
  g: TGraph;
begin
  g := {%H-}Ref;
  AssertFalse(g.NonEmpty);
  AssertTrue(g.AddVertex(11));
  AssertTrue(g.NonEmpty);
end;

procedure SparseGraphTest.NonEmptyDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
begin
  g := {%H-}Ref;
  AssertFalse(g.NonEmpty);
  AssertTrue(g.AddVertex(11));
  AssertTrue(g.NonEmpty);
end;

procedure SparseGraphTest.EnsureCapacity;
var
  Ref: TGraphRef;
  g: TGraph;
  c: SizeInt;
begin
  g := {%H-}Ref;
  g.AddVertex(11);
  c := g.Capacity;
  AssertTrue(c > 0);
  g.EnsureCapacity(c*2);
  AssertTrue(g.Capacity >= c*2);
end;

procedure SparseGraphTest.EnsureCapacityDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  c: SizeInt;
begin
  g := {%H-}Ref;
  g.AddVertex(11);
  c := g.Capacity;
  AssertTrue(c > 0);
  g.EnsureCapacity(c*2);
  AssertTrue(g.Capacity >= c*2);
end;

procedure SparseGraphTest.Clear;
var
  Ref: TGraphRef;
  g: TGraph;
begin
  g := {%H-}Ref;
  g.AddVertex(11);
  g.AddVertex(5);
  AssertTrue(g.VertexCount > 0);
  AssertTrue(g.Capacity > 0);
  g.Clear;
  AssertTrue(g.VertexCount = 0);
  AssertTrue(g.Capacity = 0);
end;

procedure SparseGraphTest.ClearDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
begin
  g := {%H-}Ref;
  g.AddVertex(11);
  g.AddVertex(5);
  AssertTrue(g.VertexCount > 0);
  AssertTrue(g.Capacity > 0);
  g.Clear;
  AssertTrue(g.VertexCount = 0);
  AssertTrue(g.Capacity = 0);
end;

procedure SparseGraphTest.AddVertex;
var
  Ref: TGraphRef;
  g: TGraph;
begin
  g := {%H-}Ref;
  AssertTrue(g.VertexCount = 0);
  AssertTrue(g.AddVertex(3));
  AssertTrue(g.VertexCount = 1);
  AssertFalse(g.AddVertex(3));
  AssertTrue(g.VertexCount = 1);
  AssertTrue(g.AddVertex(2));
  AssertTrue(g.VertexCount = 2);
end;

procedure SparseGraphTest.AddVertexDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
begin
  g := {%H-}Ref;
  AssertTrue(g.VertexCount = 0);
  AssertTrue(g.AddVertex(3));
  AssertTrue(g.VertexCount = 1);
  AssertFalse(g.AddVertex(3));
  AssertTrue(g.VertexCount = 1);
  AssertTrue(g.AddVertex(2));
  AssertTrue(g.VertexCount = 2);
end;

procedure SparseGraphTest.RemoveVertex;
var
  Ref: TGraphRef;
  g: TGraph;
  Raised: Boolean = False;
begin
  g := {%H-}Ref;
  AssertTrue(g.AddVertex(3));
  AssertTrue(g.VertexCount = 1);
  g.RemoveVertex(3);
  AssertTrue(g.VertexCount = 0);
  AssertTrue(g.AddVertex(5));
  try
    g.RemoveVertex(2);
  except
    on e: EGraphError do
      Raised := True;
  end;
  AssertTrue(Raised);
  AssertTrue(g.VertexCount = 1);
end;

procedure SparseGraphTest.RemoveVertexDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  Raised: Boolean = False;
begin
  g := {%H-}Ref;
  AssertTrue(g.AddVertex(3));
  AssertTrue(g.VertexCount = 1);
  g.RemoveVertex(3);
  AssertTrue(g.VertexCount = 0);
  AssertTrue(g.AddVertex(5));
  try
    g.RemoveVertex(2);
  except
    on e: EGraphError do
      Raised := True;
  end;
  AssertTrue(Raised);
  AssertTrue(g.VertexCount = 1);
end;

procedure SparseGraphTest.IndexOf;
var
  Ref: TGraphRef;
  g: TGraph;
  I: SizeInt;
begin
  g := {%H-}Ref;
  I := g.IndexOf(5);
  AssertTrue(I = NULL_INDEX);
  g.AddVertex(5);
  I := g.IndexOf(5);
  AssertTrue(I = 0);
  g.AddVertex(2);
  I := g.IndexOf(2);
  AssertTrue(I = 1);
  g.RemoveVertex(2);
  I := g.IndexOf(2);
  AssertTrue(I = NULL_INDEX);
end;

procedure SparseGraphTest.IndexOfDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  I: SizeInt;
begin
  g := {%H-}Ref;
  I := g.IndexOf(5);
  AssertTrue(I = NULL_INDEX);
  g.AddVertex(5);
  I := g.IndexOf(5);
  AssertTrue(I = 0);
  g.AddVertex(2);
  I := g.IndexOf(2);
  AssertTrue(I = 1);
  g.RemoveVertex(2);
  I := g.IndexOf(2);
  AssertTrue(I = NULL_INDEX);
end;

procedure SparseGraphTest.Items;
var
  Ref: TGraphRef;
  g: TGraph;
  I: SizeInt;
  Raised: Boolean = False;
begin
  g := {%H-}Ref;
  AssertTrue(g.AddVertex(5, I));
  AssertTrue(g[I] = 5);
  AssertTrue(g.AddVertex(7, I));
  AssertTrue(g[I] = 7);
  AssertTrue(g.VertexCount = 2);
  try
    I := g[2];
  except
    on e: EGraphError do
      Raised := True;
  end;
  AssertTrue(Raised);
end;

procedure SparseGraphTest.ItemsDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  I: SizeInt;
  Raised: Boolean = False;
begin
  g := {%H-}Ref;
  AssertTrue(g.AddVertex(5, I));
  AssertTrue(g[I] = 5);
  AssertTrue(g.AddVertex(7, I));
  AssertTrue(g[I] = 7);
  AssertTrue(g.VertexCount = 2);
  try
    I := g[2];
  except
    on e: EGraphError do
      Raised := True;
  end;
  AssertTrue(Raised);
end;

procedure SparseGraphTest.RemoveVertexI;
var
  Ref: TGraphRef;
  g: TGraph;
  I: SizeInt;
  Raised: Boolean = False;
begin
  g := {%H-}Ref;
  AssertTrue(g.AddVertex(3));
  AssertTrue(g.VertexCount = 1);
  I := g.IndexOf(3);
  g.RemoveVertexI(I);
  AssertTrue(g.VertexCount = 0);
  AssertTrue(g.AddVertex(5));
  I := g.IndexOf(3);
  try
    g.RemoveVertexI(I);
  except
    on e: EGraphError do
      Raised := True;
  end;
  AssertTrue(Raised);
  AssertTrue(g.VertexCount = 1);
end;

procedure SparseGraphTest.RemoveVertexIDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  I: SizeInt;
  Raised: Boolean = False;
begin
  g := {%H-}Ref;
  AssertTrue(g.AddVertex(3));
  AssertTrue(g.VertexCount = 1);
  I := g.IndexOf(3);
  g.RemoveVertexI(I);
  AssertTrue(g.VertexCount = 0);
  AssertTrue(g.AddVertex(5));
  I := g.IndexOf(3);
  try
    g.RemoveVertexI(I);
  except
    on e: EGraphError do
      Raised := True;
  end;
  AssertTrue(Raised);
  AssertTrue(g.VertexCount = 1);
end;

procedure SparseGraphTest.ContainsVertex;
var
  Ref: TGraphRef;
  g: TGraph;
begin
  g := {%H-}Ref;
  AssertFalse(g.ContainsVertex(3));
  g.AddVertex(3);
  AssertTrue(g.ContainsVertex(3));
  AssertFalse(g.ContainsVertex(5));
  g.AddVertex(5);
  AssertTrue(g.ContainsVertex(5));
end;

procedure SparseGraphTest.ContainsVertexDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
begin
  g := {%H-}Ref;
  AssertFalse(g.ContainsVertex(3));
  g.AddVertex(3);
  AssertTrue(g.ContainsVertex(3));
  AssertFalse(g.ContainsVertex(5));
  g.AddVertex(5);
  AssertTrue(g.ContainsVertex(5));
end;

procedure SparseGraphTest.AddEdge;
var
  Ref: TGraphRef;
  g: TGraph;
begin
  g := {%H-}Ref;
  AssertFalse(g.ContainsEdge(3, 5));
  AssertTrue(g.AddEdge(3, 5));
  AssertTrue(g.ContainsEdge(3, 5));
  AssertFalse(g.AddEdge(3, 5));
end;

procedure SparseGraphTest.AddArc;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
begin
  g := {%H-}Ref;
  AssertFalse(g.ContainsEdge(3, 5));
  AssertTrue(g.AddEdge(3, 5));
  AssertTrue(g.ContainsEdge(3, 5));
  AssertFalse(g.AddEdge(3, 5));
end;

procedure SparseGraphTest.AddEdgeI;
var
  Ref: TGraphRef;
  g: TGraph;
  I, J: SizeInt;
  Raised: Boolean = False;
begin
  g := {%H-}Ref;
  I := g.IndexOf(3);
  J := g.IndexOf(5);
  AssertFalse(g.ContainsEdgeI(I, J));
  try
    g.AddEdgeI(I, J);
  except
    on e: EGraphError do
      Raised := True;
  end;
  AssertTrue(Raised);
  AssertTrue(g.AddVertex(3, I));
  AssertTrue(g.AddVertex(5, J));
  AssertTrue(g.AddEdgeI(I, J));
  AssertTrue(g.ContainsEdgeI(I, J));
end;

procedure SparseGraphTest.AddEdgeIDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  I, J: SizeInt;
  Raised: Boolean = False;
begin
  g := {%H-}Ref;
  I := g.IndexOf(3);
  J := g.IndexOf(5);
  AssertFalse(g.ContainsEdgeI(I, J));
  try
    g.AddEdgeI(I, J);
  except
    on e: EGraphError do
      Raised := True;
  end;
  AssertTrue(Raised);
  AssertTrue(g.AddVertex(3, I));
  AssertTrue(g.AddVertex(5, J));
  AssertTrue(g.AddEdgeI(I, J));
  AssertTrue(g.ContainsEdgeI(I, J));
end;

procedure SparseGraphTest.Adjacent;
var
  Ref: TGraphRef;
  g: TGraph;
begin
  g := {%H-}Ref;
  AssertFalse(g.Adjacent(3, 5));
  g.AddVertex(3);
  g.AddVertex(5);
  AssertFalse(g.Adjacent(3, 5));
  g.AddEdge(3, 5);
  AssertTrue(g.Adjacent(3, 5));
  AssertTrue(g.Adjacent(5, 3));
end;

procedure SparseGraphTest.AdjacentDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
begin
  g := {%H-}Ref;
  AssertFalse(g.Adjacent(3, 5));
  g.AddVertex(3);
  g.AddVertex(5);
  AssertFalse(g.Adjacent(3, 5));
  g.AddEdge(3, 5);
  AssertTrue(g.Adjacent(3, 5));
  AssertFalse(g.Adjacent(5, 3));
end;

procedure SparseGraphTest.AdjVertices;
var
  Ref: TGraphRef;
  g: TGraph;
  I, Node: SizeInt;
begin
  g := {%H-}Ref;
  g.AddVertex(3);
  I := 0;
  for Node in g.AdjVertices(3) do
    Inc(I);
  AssertTrue(I = 0);
  g.AddEdge(3, 5);
  g.AddEdge(3, 7);
  g.AddEdge(9, 3);
  I := 0;
  for Node in g.AdjVertices(3) do
    Inc(I);
  AssertTrue(I = 3);
end;

procedure SparseGraphTest.AdjVerticesDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  I, Node: SizeInt;
begin
  g := {%H-}Ref;
  g.AddVertex(3);
  I := 0;
  for Node in g.AdjVertices(3) do
    Inc(I);
  AssertTrue(I = 0);
  g.AddEdge(3, 5);
  g.AddEdge(3, 7);
  g.AddEdge(9, 3);
  I := 0;
  for Node in g.AdjVertices(3) do
    Inc(I);
  AssertTrue(I = 2);
end;

procedure SparseGraphTest.AdjVerticesI;
var
  Ref: TGraphRef;
  g: TGraph;
  I, J, Node: SizeInt;
begin
  g := {%H-}Ref;
  g.AddVertex(3, J);
  I := 0;
  for Node in g.AdjVerticesI(J) do
    Inc(I);
  AssertTrue(I = 0);
  g.AddEdge(3, 5);
  g.AddEdge(3, 7);
  g.AddEdge(9, 3);
  I := 0;
  for Node in g.AdjVerticesI(J) do
    Inc(I);
  AssertTrue(I = 3);
end;

procedure SparseGraphTest.AdjVerticesIDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  I, J, Node: SizeInt;
begin
  g := {%H-}Ref;
  g.AddVertex(3, J);
  I := 0;
  for Node in g.AdjVerticesI(J) do
    Inc(I);
  AssertTrue(I = 0);
  g.AddEdge(3, 5);
  g.AddEdge(3, 7);
  g.AddEdge(9, 3);
  I := 0;
  for Node in g.AdjVerticesI(J) do
    Inc(I);
  AssertTrue(I = 2);
end;

procedure SparseGraphTest.Vertices;
var
  Ref: TGraphRef;
  g: TGraph;
  Vert: Integer;
  I: SizeInt;
begin
  g := {%H-}Ref;
  I := 0;
  for Vert in g.Vertices do
    Inc(I);
  g.AddVertex(3);
  I := 0;
  for Vert in g.Vertices do
    Inc(I);
  AssertTrue(I = 1);
  g.AddVertex(5);
  g.AddVertex(7);
  g.AddVertex(9);
  I := 0;
  for Vert in g.Vertices do
    Inc(I);
  AssertTrue(I = 4);
end;

procedure SparseGraphTest.VerticesDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  Vert: Integer;
  I: SizeInt;
begin
  g := {%H-}Ref;
  I := 0;
  for Vert in g.Vertices do
    Inc(I);
  g.AddVertex(3);
  I := 0;
  for Vert in g.Vertices do
    Inc(I);
  AssertTrue(I = 1);
  g.AddVertex(5);
  g.AddVertex(7);
  g.AddVertex(9);
  I := 0;
  for Vert in g.Vertices do
    Inc(I);
  AssertTrue(I = 4);
end;

procedure SparseGraphTest.IsBipartite;
var
  Ref: TGraphRef;
  g: TGraph;
  Whites, Grays: TIntArray;
  I, J: Integer;
begin
  Ref.Instance := GenerateTestGrBip1;
  g := Ref;
  AssertTrue(g.VertexCount = 16);
  AssertTrue(g.IsBipartite(Whites, Grays));
  AssertTrue(Whites.Length + Grays.Length = g.VertexCount);
  for I := 0 to Pred(Whites.Length) do
    for J := 0 to Pred(Whites.Length) do
      if I <> J then
        AssertFalse(g.AdjacentI(Whites[I], Whites[J]));
  for I := 0 to Pred(Grays.Length) do
    for J := 0 to Pred(Grays.Length) do
      if I <> J then
        AssertFalse(g.AdjacentI(Grays[I], Grays[J]));
end;

procedure SparseGraphTest.IsBipartiteDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  Whites, Grays: TIntArray;
  I, J: Integer;
begin
  Ref.Instance := GenerateTestDigrBip1;
  g := Ref;
  AssertTrue(g.VertexCount = 12);
  AssertTrue(g.IsBipartite(Whites, Grays));
  AssertTrue(Whites.Length + Grays.Length = g.VertexCount);
  for I := 0 to Pred(Whites.Length) do
    for J := 0 to Pred(Whites.Length) do
      if I <> J then
        AssertFalse(g.AdjacentI(Whites[I], Whites[J]));
  for I := 0 to Pred(Grays.Length) do
    for J := 0 to Pred(Grays.Length) do
      if I <> J then
        AssertFalse(g.AdjacentI(Grays[I], Grays[J]));
end;

procedure SparseGraphTest.DfsTraversal;
var
  Ref: TGraphRef;
  g: TGraph;
  vCount: SizeInt;
begin
  {%H-}Ref.Instance := GenerateTestGr1;
  g := Ref;
  vCount := g.VertexCount;
  AssertTrue(vCount = 13);
  FFound.InitRange(vCount);
  FDone.InitRange(vCount);
  AssertTrue(FFound.PopCount = vCount);
  AssertTrue(FDone.PopCount = vCount);
  AssertTrue(g.DfsTraversal(0, @vFound, @vDone) = vCount);
  AssertTrue(FFound.IsEmpty);
  AssertTrue(FDone.IsEmpty);
end;

procedure SparseGraphTest.DfsTraversalDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  vCount: SizeInt;
begin
  {%H-}Ref.Instance := GenerateTestDigr1;
  g := Ref;
  vCount := g.VertexCount;
  AssertTrue(vCount = 13);
  FFound.InitRange(vCount);
  FDone.InitRange(vCount);
  AssertTrue(FFound.PopCount = vCount);
  AssertTrue(FDone.PopCount = vCount);
  AssertTrue(g.DfsTraversal(0, @vFound, @vDone) = vCount - 2);
  AssertTrue(FFound.PopCount = 2);
  AssertTrue(FFound[7]);
  AssertTrue(FFound[8]);
  AssertTrue(FDone.PopCount = 2);
  AssertTrue(FDone[7]);
  AssertTrue(FDone[8]);
end;

procedure SparseGraphTest.BfsTraversal;
var
  Ref: TGraphRef;
  g: TGraph;
  vCount: SizeInt;
begin
  {%H-}Ref.Instance := GenerateTestGr1;
  g := Ref;
  vCount := g.VertexCount;
  AssertTrue(vCount = 13);
  FFound.InitRange(vCount);
  AssertTrue(FFound.PopCount = vCount);
  AssertTrue(g.BfsTraversal(0, @vFound) = vCount);
  AssertTrue(FFound.IsEmpty);
end;

procedure SparseGraphTest.BfsTraversalDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  vCount: SizeInt;
begin
  {%H-}Ref.Instance := GenerateTestDigr1;
  g := Ref;
  vCount := g.VertexCount;
  AssertTrue(vCount = 13);
  FFound.InitRange(vCount);
  AssertTrue(FFound.PopCount = vCount);
  AssertTrue(g.BfsTraversal(0, @vFound) = vCount - 2);
  AssertTrue(FFound.PopCount = 2);
  AssertTrue(FFound[7]);
  AssertTrue(FFound[8]);
end;

procedure SparseGraphTest.ShortestPaths;
var
  Ref: TGraphRef;
  g: TGraph;
  Paths: TIntArray;
const
  RightPaths: array[1..13] of SizeInt = (0, 1, 1, 1, 2, 1, 1, 2, 3, 2, 3, 3, 3);
begin
  {%H-}Ref.Instance := GenerateTestGr1;
  g := Ref;
  Paths := g.ShortestPathsMap(0);
  AssertTrue(THelper.Same(Paths, RightPaths));
end;

procedure SparseGraphTest.ShortestPathsDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
  Paths: TIntArray;
const
  RightPaths: array[1..13] of SizeInt = (0, 1, 1, 1, 2, 1, 1, -1, -1, 2, 3, 3, 3);
begin
  {%H-}Ref.Instance := GenerateTestDigr1;
  g := Ref;
  Paths := g.ShortestPathsMap(0);
  AssertTrue(THelper.Same(Paths, RightPaths));
end;

procedure SparseGraphTest.Eccentricity;
var
  Ref: TGraphRef;
  g: TGraph;
begin
  {%H-}Ref.Instance := GenerateTestGr1;
  g := Ref;
  AssertTrue(g.Eccentricity(0) = 3);
  AssertTrue(g.Eccentricity(1) = 4);
  AssertTrue(g.Eccentricity(2) = 4);
  AssertTrue(g.Eccentricity(3) = 4);
  AssertTrue(g.Eccentricity(4) = 3);
  AssertTrue(g.Eccentricity(5) = 4);
  AssertTrue(g.Eccentricity(6) = 2);
  AssertTrue(g.Eccentricity(7) = 3);
  AssertTrue(g.Eccentricity(8) = 4);
  AssertTrue(g.Eccentricity(9) = 3);
  AssertTrue(g.Eccentricity(10) = 4);
  AssertTrue(g.Eccentricity(11) = 4);
  AssertTrue(g.Eccentricity(12) = 4);
end;

procedure SparseGraphTest.EccentricityDirect;
var
  Ref: TDiGraphRef;
  g: TDiGraph;
begin
  {%H-}Ref.Instance := GenerateTestDigr1;
  g := Ref;
  AssertTrue(g.Eccentricity(0) = 3);
  AssertTrue(g.Eccentricity(1) = 0);
  AssertTrue(g.Eccentricity(2) = 4);
  AssertTrue(g.Eccentricity(3) = 3);
  AssertTrue(g.Eccentricity(4) = 2);
  AssertTrue(g.Eccentricity(5) = 0);
  AssertTrue(g.Eccentricity(6) = 2);
  AssertTrue(g.Eccentricity(7) = 3);
  AssertTrue(g.Eccentricity(8) = 4);
  AssertTrue(g.Eccentricity(9) = 1);
  AssertTrue(g.Eccentricity(10) = 0);
  AssertTrue(g.Eccentricity(11) = 1);
  AssertTrue(g.Eccentricity(12) = 0);
end;

{ TTspTest }

function TTspTest.CreateAsymmMatrix: TSolver.TTspMatrix;
begin
  //br17 from TSPLib, optimal tour cost is 39:
  Result := [
    [0,   3,  5, 48, 48,  8,  8,  5,  5,  3,  3,  0,  3,  5,  8,  8,  5],
    [3,   0,  3, 48, 48,  8,  8,  5,  5,  0,  0,  3,  0,  3,  8,  8,  5],
    [5,   3,  0, 72, 72, 48, 48, 24, 24,  3,  3,  5,  3,  0, 48, 48, 24],
    [48, 48, 74,  0,  0,  6,  6, 12, 12, 48, 48, 48, 48, 74,  6,  6, 12],
    [48, 48, 74,  0,  0,  6,  6, 12, 12, 48, 48, 48, 48, 74,  6,  6, 12],
    [8,   8, 50,  6,  6,  0,  0,  8,  8,  8,  8,  8,  8, 50,  0,  0,  8],
    [8,   8, 50,  6,  6,  0,  0,  8,  8,  8,  8,  8,  8, 50,  0,  0,  8],
    [5,   5, 26, 12, 12,  8,  8,  0,  0,  5,  5,  5,  5, 26,  8,  8,  0],
    [5,   5, 26, 12, 12,  8,  8,  0,  0,  5,  5,  5,  5, 26,  8,  8,  0],
    [3,   0,  3, 48, 48,  8,  8,  5,  5,  0,  0,  3,  0,  3,  8,  8,  5],
    [3,   0,  3, 48, 48,  8,  8,  5,  5,  0,  0,  3,  0,  3,  8,  8,  5],
    [0,   3,  5, 48, 48,  8,  8,  5,  5,  3,  3,  0,  3,  5,  8,  8,  5],
    [3,   0,  3, 48, 48,  8,  8,  5,  5,  0,  0,  3,  0,  3,  8,  8,  5],
    [5,   3,  0, 72, 72, 48, 48, 24, 24,  3,  3,  5,  3,  0, 48, 48, 24],
    [8,   8, 50,  6,  6,  0,  0,  8,  8,  8,  8,  8,  8, 50,  0,  0,  8],
    [8,   8, 50,  6,  6,  0,  0,  8,  8,  8,  8,  8,  8, 50,  0,  0,  8],
    [5,   5, 26, 12, 12,  8,  8,  0,  0,  5,  5,  5,  5, 26,  8,  8,  0]
  ]
end;

function TTspTest.CreateSymmMatrix: TSolver.TTspMatrix;
begin
  //gr17 from TSPLib, optimal tour cost is 2085:
  Result := [
    [  0, 633, 257,  91, 412, 150,  80, 134, 259, 505, 353, 324,  70, 211, 268, 246, 121],
    [633,   0, 390, 661, 227, 488, 572, 530, 555, 289, 282, 638, 567, 466, 420, 745, 518],
    [257, 390,   0, 228, 169, 112, 196, 154, 372, 262, 110, 437, 191,  74,  53, 472, 142],
    [ 91, 661, 228,   0, 383, 120,  77, 105, 175, 476, 324, 240,  27, 182, 239, 237,  84],
    [412, 227, 169, 383,   0, 267, 351, 309, 338, 196,  61, 421, 346, 243, 199, 528, 297],
    [150, 488, 112, 120, 267,   0,  63,  34, 264, 360, 208, 329,  83, 105, 123, 364,  35],
    [ 80, 572, 196,  77, 351,  63,   0,  29, 232, 444, 292, 297,  47, 150, 207, 332,  29],
    [134, 530, 154, 105, 309,  34,  29,   0, 249, 402, 250, 314,  68, 108, 165, 349,  36],
    [259, 555, 372, 175, 338, 264, 232, 249,   0, 495, 352,  95, 189, 326, 383, 202, 236],
    [505, 289, 262, 476, 196, 360, 444, 402, 495,   0, 154, 578, 439, 336, 240, 685, 390],
    [353, 282, 110, 324,  61, 208, 292, 250, 352, 154,   0, 435, 287, 184, 140, 542, 238],
    [324, 638, 437, 240, 421, 329, 297, 314,  95, 578, 435,   0, 254, 391, 448, 157, 301],
    [ 70, 567, 191,  27, 346,  83,  47,  68, 189, 439, 287, 254,   0, 145, 202, 289,  55],
    [211, 466,  74, 182, 243, 105, 150, 108, 326, 336, 184, 391, 145,   0,  57, 426,  96],
    [268, 420,  53, 239, 199, 123, 207, 165, 383, 240, 140, 448, 202,  57,   0, 483, 153],
    [246, 745, 472, 237, 528, 364, 332, 349, 202, 685, 542, 157, 289, 426, 483,   0, 336],
    [121, 518, 142,  84, 297,  35,  29,  36, 236, 390, 238, 301,  55,  96, 153, 336,   0]
  ];
end;

procedure TTspTest.Asymmetric;
var
  m: TSolver.TTspMatrix;
  Tour: TIntArray;
  Cost: Integer;
  Exact: Boolean;
begin
  m := CreateAsymmMatrix;
  Exact := TSolver.FindExact(m, Tour, Cost, 30);
  AssertTrue(Exact);
  AssertTrue(TSolver.GetTotalCost(m, Tour) = Cost);
  AssertTrue(Cost = 39);
end;

procedure TTspTest.Symmetric;
var
  m: TSolver.TTspMatrix;
  Tour: TIntArray;
  Cost: Integer;
  Exact: Boolean;
begin
  m := CreateSymmMatrix;
  Exact := TSolver.FindExact(m, Tour, Cost, 30);
  AssertTrue(Exact);
  AssertTrue(TSolver.GetTotalCost(m, Tour) = Cost);
  AssertTrue(Cost = 2085);
end;


initialization
  RegisterTest(SparseGraphTest);
  RegisterTest(TTspTest);
end.

