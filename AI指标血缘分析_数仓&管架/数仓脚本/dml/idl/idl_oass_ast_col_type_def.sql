/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_type_def
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_ast_col_type_def drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_type_def add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_type_def (
etl_dt  --ETL处理日期
,up_level_node_type_cd  --上层节点类型代码
,lev  --级别
,base_cate_flg  --基础类别标志
,spcl_info_type_cd  --专项信息类型代码
,keyw_a  --关键字段A
,effect_way_cd  --生效方式代码
,col_descb  --押品描述
,status_descb  --状态描述
,admit_cls  --准入分类
,modif_dt  --修改日期
,modif_org_id  --修改机构编号
,data_type_cd  --数据类型代码
,guar_admit_cls_cd  --担保准入分类代码
,modif_emply_id  --修改员工编号
,reval_freq_cd  --估值周期
,higt_pm_rat  --最高抵质押率
,keyw_b  --关键字段B
,gen_cd  --大类代码
,manu_idtfy_flg  --人工认定标志
,tshold  --阀值
,strip_line_cd  --条线代码
,ab_divd_cd  --AB类划分代码
,keyw_comb_use_flg  --关键字段结合使用标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志
,col_type_cd  --押品类型代码
,col_type_name  --押品类型名称

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.up_level_node_type_cd,chr(13),''),chr(10),'') as up_level_node_type_cd --上层节点类型代码
,t1.lev as lev --级别
,replace(replace(t1.base_cate_flg,chr(13),''),chr(10),'') as base_cate_flg --基础类别标志
,replace(replace(t1.spcl_info_type_cd,chr(13),''),chr(10),'') as spcl_info_type_cd --专项信息类型代码
,replace(replace(t1.keyw_a,chr(13),''),chr(10),'') as keyw_a --关键字段A
,replace(replace(t1.effect_way_cd,chr(13),''),chr(10),'') as effect_way_cd --生效方式代码
,replace(replace(t1.col_descb,chr(13),''),chr(10),'') as col_descb --押品描述
,replace(replace(t1.status_descb,chr(13),''),chr(10),'') as status_descb --状态描述
,replace(replace(t1.admit_cls,chr(13),''),chr(10),'') as admit_cls --准入分类
,t1.modif_dt as modif_dt --修改日期
,replace(replace(t1.modif_org_id,chr(13),''),chr(10),'') as modif_org_id --修改机构编号
,replace(replace(t1.data_type_cd,chr(13),''),chr(10),'') as data_type_cd --数据类型代码
,replace(replace(t1.guar_admit_cls_cd,chr(13),''),chr(10),'') as guar_admit_cls_cd --担保准入分类代码
,replace(replace(t1.modif_emply_id,chr(13),''),chr(10),'') as modif_emply_id --修改员工编号
,replace(replace(t1.reval_freq_cd,chr(13),''),chr(10),'') as reval_freq_cd --估值周期
,t1.higt_pm_rat as higt_pm_rat --最高抵质押率
,replace(replace(t1.keyw_b,chr(13),''),chr(10),'') as keyw_b --关键字段B
,replace(replace(t1.gen_cd,chr(13),''),chr(10),'') as gen_cd --大类代码
,replace(replace(t1.manu_idtfy_flg,chr(13),''),chr(10),'') as manu_idtfy_flg --人工认定标志
,t1.tshold as tshold --阀值
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd --条线代码
,replace(replace(t1.ab_divd_cd,chr(13),''),chr(10),'') as ab_divd_cd --AB类划分代码
,replace(replace(t1.keyw_comb_use_flg,chr(13),''),chr(10),'') as keyw_comb_use_flg --关键字段结合使用标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.col_type_cd,chr(13),''),chr(10),'') as col_type_cd --押品类型代码
,replace(replace(t1.col_type_name,chr(13),''),chr(10),'') as col_type_name --押品类型名称
from ${iml_schema}.ast_col_type_def t1    --押品类型定义表
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_type_def',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
