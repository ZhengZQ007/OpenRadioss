Copyright>        OpenRadioss
Copyright>        Copyright (C) 1986-2023 Altair Engineering Inc.
Copyright>
Copyright>        This program is free software: you can redistribute it and/or modify
Copyright>        it under the terms of the GNU Affero General Public License as published by
Copyright>        the Free Software Foundation, either version 3 of the License, or
Copyright>        (at your option) any later version.
Copyright>
Copyright>        This program is distributed in the hope that it will be useful,
Copyright>        but WITHOUT ANY WARRANTY; without even the implied warranty of
Copyright>        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
Copyright>        GNU Affero General Public License for more details.
Copyright>
Copyright>        You should have received a copy of the GNU Affero General Public License
Copyright>        along with this program.  If not, see <https://www.gnu.org/licenses/>.
Copyright>
Copyright>
Copyright>        Commercial Alternative: Altair Radioss Software
Copyright>
Copyright>        As an alternative to this open-source version, Altair also offers Altair Radioss
Copyright>        software under a commercial license.  Contact Altair to discuss further if the
Copyright>        commercial version may interest you: https://www.altair.com/radioss/.
Chd|====================================================================
Chd|  MAT_ELEM_MOD                  modules/mat_elem/mat_elem_mod.F
Chd|-- called by -----------
Chd|        CONTRL                        starter/source/starter/contrl.F
Chd|        LECTUR                        starter/source/starter/lectur.F
Chd|        READ_MATERIAL_MODELS          starter/source/materials/read_material_models.F
Chd|        STARTER0                      starter/source/starter/starter0.F
Chd|        BFORC2                        engine/source/ale/bimat/bforc2.F
Chd|        C3FORC3                       engine/source/elements/sh3n/coque3n/c3forc3.F
Chd|        C3FORC3_CRK                   engine/source/elements/xfem/c3forc3_crk.F
Chd|        CBAFORC3                      engine/source/elements/shell/coqueba/cbaforc3.F
Chd|        CDK6FORC3                     engine/source/elements/sh3n/coquedk6/cdk6forc3.F
Chd|        CDKFORC3                      engine/source/elements/sh3n/coquedk/cdkforc3.F
Chd|        CFORC3                        engine/source/elements/shell/coque/cforc3.F
Chd|        CFORC3_CRK                    engine/source/elements/xfem/cforc3_crk.F
Chd|        CMAIN3                        engine/source/materials/mat_share/cmain3.F
Chd|        CZFORC3                       engine/source/elements/shell/coquez/czforc3.F
Chd|        CZFORC3_CRK                   engine/source/elements/xfem/czforc3_crk.F
Chd|        FORINT                        engine/source/elements/forint.F
Chd|        FORINTC                       engine/source/elements/forintc.F
Chd|        FORINTP                       engine/source/elements/forintp.F
Chd|        IG3DUFORC3                    engine/source/elements/ige3d/ig3duforc3.F
Chd|        MMAIN                         engine/source/materials/mat_share/mmain.F
Chd|        MULAW                         engine/source/materials/mat_share/mulaw.F
Chd|        MULAWC                        engine/source/materials/mat_share/mulawc.F
Chd|        Q4FORC2                       engine/source/elements/solid_2d/quad4/q4forc2.F
Chd|        QFORC2                        engine/source/elements/solid_2d/quad/qforc2.F
Chd|        RADIOSS2                      engine/source/engine/radioss2.F
Chd|        RDCOMI                        engine/source/output/restart/rdcomm.F
Chd|        RDRESA                        engine/source/output/restart/rdresa.F
Chd|        RDRESB                        engine/source/output/restart/rdresb.F
Chd|        READ_MATPARAM                 engine/source/output/restart/read_matparam.F
Chd|        RESOL                         engine/source/engine/resol.F  
Chd|        RESOL_HEAD                    engine/source/engine/resol_head.F
Chd|        S10FORC3                      engine/source/elements/solid/solide10/s10forc3.F
Chd|        S16FORC3                      engine/source/elements/thickshell/solide16/s16forc3.F
Chd|        S20FORC3                      engine/source/elements/solid/solide20/s20forc3.F
Chd|        S4FORC3                       engine/source/elements/solid/solide4/s4forc3.F
Chd|        S6CFORC3                      engine/source/elements/thickshell/solide6c/s6cforc3.F
Chd|        S8CFORC3                      engine/source/elements/thickshell/solide8c/s8cforc3.F
Chd|        S8EFORC3                      engine/source/elements/solid/solide8e/s8eforc3.F
Chd|        S8SFORC3                      engine/source/elements/solid/solide8s/s8sforc3.F
Chd|        S8ZFORC3                      engine/source/elements/solid/solide8z/s8zforc3.F
Chd|        SCFORC3                       engine/source/elements/thickshell/solidec/scforc3.F
Chd|        SFORC3                        engine/source/elements/solid/solide/sforc3.F
Chd|        SPSTRES                       engine/source/elements/sph/spstres.F
Chd|        SZFORC3                       engine/source/elements/solid/solidez/szforc3.F
Chd|        WRRESTP                       engine/source/output/restart/wrrestp.F
Chd|-- calls ---------------
Chd|        ELBUFDEF_MOD                  modules/mat_elem/elbufdef_mod.F
Chd|        GROUP_PARAM_MOD               modules/mat_elem/group_param_mod.F
Chd|        MATPARAM_DEF_MOD              modules/mat_elem/matparam_def_mod.F
Chd|        PROP_PARAM_MOD                modules/mat_elem/prop_param_mod.F
Chd|====================================================================
      MODULE MAT_ELEM_MOD
        USE ELBUFDEF_MOD
        USE MATPARAM_DEF_MOD
        USE PROP_PARAM_MOD
        USE GROUP_PARAM_MOD

        TYPE MAT_ELEM_
           INTEGER :: NGROUP       ! Number of element groups
           INTEGER :: NUMMAT       ! Number of /MAT  cards
           INTEGER :: NUMGEO       ! Number of /PROP cards
           INTEGER :: NUMSUBSTACK  ! Number of SUBSTACK created from /PROP/TYPE17, TYPE51 or TYPE52 => NS_STACK (see stackgroup.F)
           INTEGER :: NUMSTACK     ! Number of /STACK  used with /PCOMPP
           INTEGER :: NUMPLY       ! Number of /PLY    used with /PCOMPP

           TYPE (ELBUF_STRUCT_)    ,DIMENSION(:)   ,ALLOCATABLE :: ELBUF          ! NGROUP
           TYPE (ELBUF_STRUCT_)    ,DIMENSION(:,:) ,ALLOCATABLE :: XFEM_TAB       
           TYPE (GROUP_PARAM_)     ,DIMENSION(:)   ,ALLOCATABLE :: GROUP_PARAM    ! NGROUP
        
           TYPE (MATPARAM_STRUCT_) ,DIMENSION(:)   ,POINTER     :: MAT_PARAM      ! NUMMAT
        
           TYPE (PROP_PARAM_)      ,DIMENSION(:)   ,ALLOCATABLE :: PROP_PARAM     ! NUMGEO
           TYPE (PROP_PARAM_)      ,DIMENSION(:)   ,ALLOCATABLE :: PROP_STACK     ! NUMSTACK
           TYPE (PROP_PARAM_)      ,DIMENSION(:)   ,ALLOCATABLE :: PROP_PLY       ! NUMPLY
           TYPE (PROP_PARAM_)      ,DIMENSION(:)   ,ALLOCATABLE :: PROP_SUBSTACK  ! NUMSUBSTACK      
     
        END TYPE MAT_ELEM_

      END MODULE MAT_ELEM_MOD