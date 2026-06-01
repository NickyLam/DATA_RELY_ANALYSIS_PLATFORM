/*
Purpose:    IDL-KPI考核得分明细
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mc_kpi_asses_scor_jg_dtl
CreateDate: None
FileType:   DML
Logs:
    表英文名： mc_kpi_asses_scor_jg_dtl
    表中文名： KPI考核得分明细
    创建日期： None
    主键字段： 数据日期
    归属层次： IDL
    归属主题： None
    分区粒度： 
    分析人员： None
    时间粒度： 日
    保留周期： 永久
    描述信息： None
    更新记录:
        2025-12-18    郑沛隆    新建脚本    
        2026-03-18    郑沛隆    补充系统出数    
        2026-03-23    郑沛隆    将补录数据后补到正常出数逻辑中进行互补    
*/


--设置参数
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- 1.1 create table for exchage
whenever sqlerror continue none;
alter table ${idl_schema}.mc_kpi_asses_scor_jg_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mc_kpi_asses_scor_jg_dtl truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--临时表01:获取补录数据
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_kpi_asses_scor_jg_dtl_01 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_kpi_asses_scor_jg_dtl_01 (
    stat_dt varchar2(200)                                         --统计日期
    ,sup_org_no varchar2(200) --上级机构编号
    ,org_no varchar2(200) --机构编号
    ,org_name varchar2(200) --机构名称
    ,prop_id varchar2(20) --方案编号
    -- 5
    ,prop_name varchar2(100) --方案名称
    ,ind_name varchar2(200) --指标名称
    ,sup_ind_seq varchar2(30) --上级指标序号
    ,sup_ind_name varchar2(200) --上级指标名称
    ,std_scor number(12,6) --标准得分
    -- 10
    ,scor_uplmi number(25,4) --得分上限
    ,scor_lolmi number(25,4) --得分下限
    ,year_target_val number(25,4) --年度目标值
    ,tm_prog_val number(25,4) --时间进度值
    ,base_val number(25,4) --基数
    -- 15
    ,ind_val number(25,4) --指标值
    ,net_incre number(25,4) --净增值
    ,asses_scor number(25,4) --考核得分
    ,year_cmplt_rat number(12,6) --年度完成率
    ,tm_prog_cmplt_rat number(12,6) --时间进度完成率
    -- 20
    ,seq_num number --序号
    ,belong_comb varchar2(30) --归属组别
    ,unit varchar2(30) --指标单位
    ,ind_no varchar2(100) --指标编号
    ,etl_dt date --ETL处理日期
    -- 25
    ,etl_timestamp timestamp(6) --ETL处理时间戳
)
 ;

insert into ${idl_schema}.tmp_mc_kpi_asses_scor_jg_dtl_01(
    stat_dt                                                      --统计日期
    ,sup_org_no                                                  --上级机构编号
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,prop_id                                                     --方案编号
    -- 5
    ,prop_name                                                   --方案名称
    ,ind_name                                                    --指标名称
    ,sup_ind_seq                                                 --上级指标序号
    ,sup_ind_name                                                --上级指标名称
    ,std_scor                                                    --标准得分
    -- 10
    ,scor_uplmi                                                  --得分上限
    ,scor_lolmi                                                  --得分下限
    ,year_target_val                                             --年度目标值
    ,tm_prog_val                                                 --时间进度值
    ,base_val                                                    --基数
    -- 15
    ,ind_val                                                     --指标值
    ,net_incre                                                   --净增值
    ,asses_scor                                                  --考核得分
    ,year_cmplt_rat                                              --年度完成率
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    -- 20
    ,seq_num                                                     --序号
    ,belong_comb                                                 --归属组别
    ,unit                                                        --指标单位
    ,ind_no                                                      --指标编号
    ,etl_dt                                                      --ETL处理日期
    -- 25
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    '${batch_date}' as stat_dt                                   --统计日期
    ,t2.super_org_id as sup_org_no                               --上级机构编号
    ,t2.org_no as org_no                                         --机构编号
    ,t2.org_name as org_name                                     --机构名称
    ,'' as prop_id                                               --方案编号
    -- 5
    ,'' as prop_name                                             --方案名称
    ,t1.index_name as ind_name                                   --指标名称
    ,case when to_date('${batch_date}','yyyymmdd')<= to_date('20251231','yyyymmdd') and t3.belong_cls='条线管理部门' then null
 else t3.super_index_no_mcs end as sup_ind_seq --None
    ,case when to_date('${batch_date}','yyyymmdd')<= to_date('20251231','yyyymmdd') and t3.belong_cls='条线管理部门' then t3.index_class_s_mcs 
 else t3.super_index_name_mcs end as sup_ind_name --None
    ,t1.std_scor as std_scor                                     --标准得分
    -- 10
    ,t1.scor_uplmi as scor_uplmi                                 --得分上限
    ,t1.scor_lolmi as scor_lolmi                                 --得分下限
    ,t1.budget_val as year_target_val                            --年度目标值
    ,t1.PROG_TARGET_VAL as tm_prog_val                           --时间进度值
    ,t1.last_year_base as base_val                               --基数
    -- 15
    ,t1.index_val as ind_val                                     --指标值
    ,t1.net_incre as net_incre                                   --净增值
    ,trunc(t1.asses_scor,2) as asses_scor                        --考核得分
    ,t1.year_cmplt_rat*100 as year_cmplt_rat                     --年度完成率
    ,t1.tm_prog_cmplt_rat*100 as tm_prog_cmplt_rat               --时间进度完成率
    -- 20
    ,'' as seq_num                                               --序号
    ,null as belong_comb                                         --归属组别
    ,t3.unit as unit                                             --None
    ,t3.index_no_mcs as ind_no                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 25
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_kpi_asses_scor_jg_dtl_bl t1 --KPI考核得分明细补录表 
LEFT JOIN mc_orga_para_jxkh t2 --绩效考核机构表 
 on t1.org_no=t2.org_no
and t2.org_level in ('分行','事业部','条线管理部门')
INNER JOIN mc_asses_index_define t3 --考核模块指标定义表 
 on t1.index_no=t3.index_no_mcs
and t3.module_name='KPI得分情况'
and t3.belong_cls=t2.org_level
and t3.etl_dt=to_date('${batch_date}','yyyymmdd')
where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
AND  t3.index_state='在用'
 ;
commit;


/*==============第2组==============*/

--临时表02:获取系统数据
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_kpi_asses_scor_jg_dtl_02 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_kpi_asses_scor_jg_dtl_02 (
    stat_dt varchar2(200)                                         --统计日期
    ,sup_org_no varchar2(200) --上级机构编号
    ,org_no varchar2(200) --机构编号
    ,org_name varchar2(200) --机构名称
    ,prop_id varchar2(20) --方案编号
    -- 5
    ,prop_name varchar2(100) --方案名称
    ,ind_name varchar2(200) --指标名称
    ,sup_ind_seq varchar2(30) --上级指标序号
    ,sup_ind_name varchar2(200) --上级指标名称
    ,std_scor number(12,6) --标准得分
    -- 10
    ,scor_uplmi number(25,4) --得分上限
    ,scor_lolmi number(25,4) --得分下限
    ,year_target_val number(25,4) --年度目标值
    ,tm_prog_val number(25,4) --时间进度值
    ,base_val number(25,4) --基数
    -- 15
    ,ind_val number(25,4) --指标值
    ,net_incre number(25,4) --净增值
    ,asses_scor number(25,4) --考核得分
    ,year_cmplt_rat number(12,6) --年度完成率
    ,tm_prog_cmplt_rat number(12,6) --时间进度完成率
    -- 20
    ,seq_num number --序号
    ,belong_comb varchar2(30) --归属组别
    ,unit varchar2(30) --指标单位
    ,ind_no varchar2(100) --指标编号
    ,etl_dt date --ETL处理日期
    -- 25
    ,etl_timestamp timestamp(6) --ETL处理时间戳
)
 ;

insert into ${idl_schema}.tmp_mc_kpi_asses_scor_jg_dtl_02(
    stat_dt                                                      --统计日期
    ,sup_org_no                                                  --上级机构编号
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,prop_id                                                     --方案编号
    -- 5
    ,prop_name                                                   --方案名称
    ,ind_name                                                    --指标名称
    ,sup_ind_seq                                                 --上级指标序号
    ,sup_ind_name                                                --上级指标名称
    ,std_scor                                                    --标准得分
    -- 10
    ,scor_uplmi                                                  --得分上限
    ,scor_lolmi                                                  --得分下限
    ,year_target_val                                             --年度目标值
    ,tm_prog_val                                                 --时间进度值
    ,base_val                                                    --基数
    -- 15
    ,ind_val                                                     --指标值
    ,net_incre                                                   --净增值
    ,asses_scor                                                  --考核得分
    ,year_cmplt_rat                                              --年度完成率
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    -- 20
    ,seq_num                                                     --序号
    ,belong_comb                                                 --归属组别
    ,unit                                                        --指标单位
    ,ind_no                                                      --指标编号
    ,etl_dt                                                      --ETL处理日期
    -- 25
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    '${batch_date}' as stat_dt                                   --None
    ,t1.super_org_id as sup_org_no                               --None
    ,t1.org_no as org_no                                         --None
    ,t1.org_name as org_name                                     --None
    ,to_char(t6.fabh) as prop_id                                 --None
    -- 5
    ,t6.famc as prop_name                                        --None
    ,t4.index_name_mcs as ind_name                               --None
    ,t4.super_index_no_mcs as sup_ind_seq                        --None
    ,t4.super_index_name_mcs as sup_ind_name                     --None
    ,t3.bzdf as std_scor                                         --None
    -- 10
    ,t3.dfsx as scor_uplmi                                       --None
    ,t3.dfxx as scor_lolmi                                       --None
    ,t3.ndmbz/decode(t4.unit,'万元',10000,'亿元',100000000,1) as year_target_val --None
    ,t3.sjjdz/decode(t4.unit,'万元',10000,'亿元',100000000,1) as tm_prog_val --None
    ,t3.js/decode(t4.unit,'万元',10000,'亿元',100000000,1) as base_val --None
    -- 15
    ,t3.zbz/decode(t4.unit,'万元',10000,'亿元',100000000,1) as ind_val --None
    ,t3.jzz/decode(t4.unit,'万元',10000,'亿元',100000000,1) as net_incre --None
    ,trunc(t3.khdf,2) as asses_scor                              --None
    ,t3.ndwcl as year_cmplt_rat                                  --None
    ,t3.sjjdwcl as tm_prog_cmplt_rat                             --None
    -- 20
    ,'' as seq_num                                               --None
    ,'' as belong_comb                                           --None
    ,t4.unit as unit                                             --None
    ,t4.index_no_mcs as ind_no                                   --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 25
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_orga_para_jxkh t1 --绩效考核机构表 
LEFT JOIN itl_edw_pams_khdx_jg t2 --考核对象-机构 
 on t1.org_no=t2.jgdh
 and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN itl_edw_pams_jxbb_kpikhdfmx_jg t3 --绩效报表_KPI考核得分明细_机构 
 on t3.tjrq = '${batch_date}'
 and t3.khdxdh = t2.khdxdh
INNER JOIN (select regexp_substr(index_no, 'fabh:(\d+)', 1, 1, null, 1) as fabh
      ,regexp_substr(index_no, 'xh:(\d+)', 1, 1, null, 1) as xh
      ,index_no_mcs
      ,index_name_mcs
      ,super_index_no_mcs
      ,super_index_name_mcs
      ,index_class_f_mcs
      ,unit
  from mc_asses_index_define
 where etl_dt = to_date('${batch_date}','yyyymmdd')
       and module_name = 'KPI得分情况') t4 --考核模块指标定义表 
 on t3.fabh=t4.fabh
 and t3.xh=t4.xh
 --and t4.index_name_mcs <> '总分'
INNER JOIN itl_edw_pams_khfa_level_manage t5 --考核方案层级管理 
 on t3.fabh=t5.fabh
 and t3.xh=t5.xh
 and t5.etl_dt = to_date('${batch_date}','yyyymmdd')
LEFT JOIN itl_edw_pams_khfa_fapz t6 --考核方案-方案配置 
 on t3.fabh=t6.fabh
 and t6.etl_dt = to_date('${batch_date}','yyyymmdd')
where t1.org_level in ('分行', '条线管理部门', '事业部')
 and t1.remark is not null
 ;
commit;


/*==============第3组==============*/

--KPI考核得分明细:插入目标表
insert into ${idl_schema}.mc_kpi_asses_scor_jg_dtl(
    stat_dt                                                      --统计日期
    ,sup_org_no                                                  --上级机构编号
    ,org_no                                                      --机构编号
    ,org_name                                                    --机构名称
    ,prop_id                                                     --方案编号
    -- 5
    ,prop_name                                                   --方案名称
    ,ind_name                                                    --指标名称
    ,sup_ind_seq                                                 --上级指标序号
    ,sup_ind_name                                                --上级指标名称
    ,std_scor                                                    --标准得分
    -- 10
    ,scor_uplmi                                                  --得分上限
    ,scor_lolmi                                                  --得分下限
    ,year_target_val                                             --年度目标值
    ,tm_prog_val                                                 --时间进度值
    ,base_val                                                    --基数
    -- 15
    ,ind_val                                                     --指标值
    ,net_incre                                                   --净增值
    ,asses_scor                                                  --考核得分
    ,year_cmplt_rat                                              --年度完成率
    ,tm_prog_cmplt_rat                                           --时间进度完成率
    -- 20
    ,seq_num                                                     --序号
    ,belong_comb                                                 --归属组别
    ,unit                                                        --指标单位
    ,ind_no                                                      --指标编号
    ,etl_dt                                                      --ETL处理日期
    -- 25
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    '${batch_date}' as stat_dt                                   --统计日期
    ,coalesce(t2.sup_org_no,t1.sup_org_no) as sup_org_no         --上级机构编号
    ,coalesce(t2.org_no,t1.org_no) as org_no                     --机构编号
    ,coalesce(t2.org_name,t1.org_name) as org_name               --机构名称
    ,coalesce(t2.prop_id,t1.prop_id) as prop_id                  --方案编号
    -- 5
    ,coalesce(t2.prop_name,t1.prop_name) as prop_name            --方案名称
    ,coalesce(t2.ind_name,t1.ind_name) as ind_name               --指标名称
    ,coalesce(t2.sup_ind_seq,t1.sup_ind_seq) as sup_ind_seq      --上级指标序号
    ,coalesce(t2.sup_ind_name,t1.sup_ind_name) as sup_ind_name   --上级指标名称
    ,coalesce(t2.std_scor,t1.std_scor) as std_scor               --标准得分
    -- 10
    ,coalesce(t2.scor_uplmi,t1.scor_uplmi) as scor_uplmi         --得分上限
    ,coalesce(t2.scor_lolmi,t1.scor_lolmi) as scor_lolmi         --得分下限
    ,coalesce(t2.year_target_val,t1.year_target_val) as year_target_val --年度目标值
    ,coalesce(t2.tm_prog_val,t1.tm_prog_val) as tm_prog_val      --时间进度值
    ,coalesce(t2.base_val,t1.base_val) as base_val               --基数
    -- 15
    ,coalesce(t2.ind_val,t1.ind_val) as ind_val                  --指标值
    ,coalesce(t2.net_incre,t1.net_incre) as net_incre            --净增值
    ,coalesce(t2.asses_scor,t1.asses_scor) as asses_scor         --考核得分
    ,coalesce(t2.year_cmplt_rat,t1.year_cmplt_rat) as year_cmplt_rat --年度完成率
    ,coalesce(t2.tm_prog_cmplt_rat,t1.tm_prog_cmplt_rat) as tm_prog_cmplt_rat --时间进度完成率
    -- 20
    ,coalesce(t2.seq_num,t1.seq_num) as seq_num                  --序号
    ,coalesce(t2.belong_comb,t1.belong_comb) as belong_comb      --归属组别
    ,coalesce(t2.unit,t1.unit) as unit                           --指标单位
    ,coalesce(t2.ind_no,t1.ind_no) as ind_no                     --指标编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 25
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_kpi_asses_scor_jg_dtl_02 t1 --临时表02 
FULL JOIN tmp_mc_kpi_asses_scor_jg_dtl_01 t2 --临时表01 
 on t1.org_no=t2.org_no
 and t1.ind_no=t2.ind_no
 and t1.ind_name=t2.ind_name
 and t1.etl_dt = t2.etl_dt

where t1.etl_dt = to_date('${batch_date}','yyyymmdd') 
 or t2.etl_dt = to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_kpi_asses_scor_jg_dtl_01 purge;
drop table ${idl_schema}.tmp_mc_kpi_asses_scor_jg_dtl_02 purge;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_kpi_asses_scor_jg_dtl', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cAScade => true);
