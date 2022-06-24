import Lean
open Lean Elab

elab (name := includeStr) "include_str " str:str : term => do
  let some str := str.isStrLit? | Lean.Elab.throwUnsupportedSyntax
  let ctx ← readThe Lean.Core.Context
  let srcPath := System.FilePath.mk ctx.fileName
  let some srcDir := srcPath.parent | throwError "{srcPath} not in a valid directory"
  let path := srcDir / str
  Lean.mkStrLit <$> IO.FS.readFile path

@[widgetSource]
def rubiks : String := include_str "./widget/dist/rubiks.js"

structure RubiksProps where
  seq : Array String := #[]
  deriving ToJson, FromJson, Inhabited

def eg : RubiksProps := {seq := #["D", "D", "D⁻¹", "R⁻¹"]}

#widget rubiks (toJson eg)