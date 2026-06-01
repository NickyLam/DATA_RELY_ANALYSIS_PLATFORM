/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_guar_qual_idtfy_mimsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_tm purge;
drop table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_guar_qual_idtfy add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_guar_qual_idtfy modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_guar_qual_idtfy partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,asset_and_brwer_pc_flg -- 资产与借款人正相关标志
    ,guar_impt_flg -- 保证落实标志
    ,guar_rela_cd -- 保证相关性代码
    ,guar_rela_rest_cd -- 保证相关结果代码
    ,wt_md_guar_cls_qual_flg -- 权重法担保分类合格标志
    ,wt_md_dr_tool_qual_flg -- 权重法缓释工具合格标志
    ,wt_md_qual_dr_tool_cate_cd -- 权重法合格缓释工具类别代码
    ,np_guar_cls_qual_flg -- 内评初级法担保分类合格标志
    ,np_qual_dr_tool_flg -- 内评初级法合格缓释工具标志
    ,np_qual_dr_tool_cate_cd -- 内评初级法合格缓释工具类别代码
    ,guar_amt -- 担保金额
    ,mtg_rat -- 抵质押率
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_guar_qual_idtfy
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_guar_qual_idtfy partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_asscontractqualify-
insert into ${iml_schema}.ast_guar_qual_idtfy_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,asset_and_brwer_pc_flg -- 资产与借款人正相关标志
    ,guar_impt_flg -- 保证落实标志
    ,guar_rela_cd -- 保证相关性代码
    ,guar_rela_rest_cd -- 保证相关结果代码
    ,wt_md_guar_cls_qual_flg -- 权重法担保分类合格标志
    ,wt_md_dr_tool_qual_flg -- 权重法缓释工具合格标志
    ,wt_md_qual_dr_tool_cate_cd -- 权重法合格缓释工具类别代码
    ,np_guar_cls_qual_flg -- 内评初级法担保分类合格标志
    ,np_qual_dr_tool_flg -- 内评初级法合格缓释工具标志
    ,np_qual_dr_tool_cate_cd -- 内评初级法合格缓释工具类别代码
    ,guar_amt -- 担保金额
    ,mtg_rat -- 抵质押率
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.APPLYCODE -- 担保合同编号
    ,P1.ISRELATION -- 资产与借款人正相关标志
    ,P1.ISWORKABLE -- 保证落实标志
    ,NVL(TRIM(P1.GUARRELATION),'00') -- 保证相关性代码
    ,NVL(TRIM(P1.GUARRESULT),'00') -- 保证相关结果代码
    ,P1.QZTYPEISHG -- 权重法担保分类合格标志
    ,P1.QZISHGTOOLS -- 权重法缓释工具合格标志
    ,NVL(TRIM(P1.QZHGTOOLSTYPE),'00') -- 权重法合格缓释工具类别代码
    ,P1.NPTYPEISHG -- 内评初级法担保分类合格标志
    ,P1.NPISHGTOOLS -- 内评初级法合格缓释工具标志
    ,NVL(TRIM(P1.NPHGTOOLSTYPE),'00') -- 内评初级法合格缓释工具类别代码
    ,P1.GUARMONEY -- 担保金额
    ,P1.GUARRATE -- 抵质押率
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.BZGUARMETHOD END -- 保证担保形式代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BZMETHOD END -- 担保方式代码
    ,NVL(TRIM(P1.GUARCURRENCY),'CNY') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_asscontractqualify' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_asscontractqualify p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BZGUARMETHOD = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MIMS'
        AND R1.SRC_TAB_EN_NAME= 'MIMS_SI_ASSCONTRACTQUALIFY'
        AND R1.SRC_FIELD_EN_NAME= 'BZMETHOD'
        AND R1.TARGET_TAB_EN_NAME= 'AST_GUAR_QUAL_IDTFY'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'GUAR_WAY_CD'    
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.BZGUARMETHOD = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MIMS'
        AND R5.SRC_TAB_EN_NAME= 'MIMS_SI_ASSCONTRACTQUALIFY'
        AND R5.SRC_FIELD_EN_NAME= 'BZGUARMETHOD'
        AND R5.TARGET_TAB_EN_NAME= 'AST_GUAR_QUAL_IDTFY'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'GUAR_GUAR_FORM_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_guar_qual_idtfy_mimsf1_tm 
  	                                group by 
  	                                        asset_id
  	                                        ,lp_id
  	                                        ,guar_cont_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ast_guar_qual_idtfy_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,guar_cont_id -- 担保合同编号
    ,asset_and_brwer_pc_flg -- 资产与借款人正相关标志
    ,guar_impt_flg -- 保证落实标志
    ,guar_rela_cd -- 保证相关性代码
    ,guar_rela_rest_cd -- 保证相关结果代码
    ,wt_md_guar_cls_qual_flg -- 权重法担保分类合格标志
    ,wt_md_dr_tool_qual_flg -- 权重法缓释工具合格标志
    ,wt_md_qual_dr_tool_cate_cd -- 权重法合格缓释工具类别代码
    ,np_guar_cls_qual_flg -- 内评初级法担保分类合格标志
    ,np_qual_dr_tool_flg -- 内评初级法合格缓释工具标志
    ,np_qual_dr_tool_cate_cd -- 内评初级法合格缓释工具类别代码
    ,guar_amt -- 担保金额
    ,mtg_rat -- 抵质押率
    ,guar_guar_form_cd -- 保证担保形式代码
    ,guar_way_cd -- 担保方式代码
    ,curr_cd -- 币种代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.guar_cont_id, o.guar_cont_id) as guar_cont_id -- 担保合同编号
    ,nvl(n.asset_and_brwer_pc_flg, o.asset_and_brwer_pc_flg) as asset_and_brwer_pc_flg -- 资产与借款人正相关标志
    ,nvl(n.guar_impt_flg, o.guar_impt_flg) as guar_impt_flg -- 保证落实标志
    ,nvl(n.guar_rela_cd, o.guar_rela_cd) as guar_rela_cd -- 保证相关性代码
    ,nvl(n.guar_rela_rest_cd, o.guar_rela_rest_cd) as guar_rela_rest_cd -- 保证相关结果代码
    ,nvl(n.wt_md_guar_cls_qual_flg, o.wt_md_guar_cls_qual_flg) as wt_md_guar_cls_qual_flg -- 权重法担保分类合格标志
    ,nvl(n.wt_md_dr_tool_qual_flg, o.wt_md_dr_tool_qual_flg) as wt_md_dr_tool_qual_flg -- 权重法缓释工具合格标志
    ,nvl(n.wt_md_qual_dr_tool_cate_cd, o.wt_md_qual_dr_tool_cate_cd) as wt_md_qual_dr_tool_cate_cd -- 权重法合格缓释工具类别代码
    ,nvl(n.np_guar_cls_qual_flg, o.np_guar_cls_qual_flg) as np_guar_cls_qual_flg -- 内评初级法担保分类合格标志
    ,nvl(n.np_qual_dr_tool_flg, o.np_qual_dr_tool_flg) as np_qual_dr_tool_flg -- 内评初级法合格缓释工具标志
    ,nvl(n.np_qual_dr_tool_cate_cd, o.np_qual_dr_tool_cate_cd) as np_qual_dr_tool_cate_cd -- 内评初级法合格缓释工具类别代码
    ,nvl(n.guar_amt, o.guar_amt) as guar_amt -- 担保金额
    ,nvl(n.mtg_rat, o.mtg_rat) as mtg_rat -- 抵质押率
    ,nvl(n.guar_guar_form_cd, o.guar_guar_form_cd) as guar_guar_form_cd -- 保证担保形式代码
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
                and o.guar_cont_id is null
            ) or (
                o.asset_and_brwer_pc_flg <> n.asset_and_brwer_pc_flg
                or o.guar_impt_flg <> n.guar_impt_flg
                or o.guar_rela_cd <> n.guar_rela_cd
                or o.guar_rela_rest_cd <> n.guar_rela_rest_cd
                or o.wt_md_guar_cls_qual_flg <> n.wt_md_guar_cls_qual_flg
                or o.wt_md_dr_tool_qual_flg <> n.wt_md_dr_tool_qual_flg
                or o.wt_md_qual_dr_tool_cate_cd <> n.wt_md_qual_dr_tool_cate_cd
                or o.np_guar_cls_qual_flg <> n.np_guar_cls_qual_flg
                or o.np_qual_dr_tool_flg <> n.np_qual_dr_tool_flg
                or o.np_qual_dr_tool_cate_cd <> n.np_qual_dr_tool_cate_cd
                or o.guar_amt <> n.guar_amt
                or o.mtg_rat <> n.mtg_rat
                or o.guar_guar_form_cd <> n.guar_guar_form_cd
                or o.guar_way_cd <> n.guar_way_cd
                or o.curr_cd <> n.curr_cd
            ) or (
                 case when (
                           n.asset_id is null
                           and n.lp_id is null
                           and n.guar_cont_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.asset_id is null
                and n.lp_id is null
                and n.guar_cont_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_guar_qual_idtfy_mimsf1_tm n
    full join ${iml_schema}.ast_guar_qual_idtfy_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
            and o.guar_cont_id = n.guar_cont_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_guar_qual_idtfy truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_guar_qual_idtfy exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_guar_qual_idtfy drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_guar_qual_idtfy to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_tm purge;
drop table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_ex purge;
drop table ${iml_schema}.ast_guar_qual_idtfy_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_guar_qual_idtfy', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);