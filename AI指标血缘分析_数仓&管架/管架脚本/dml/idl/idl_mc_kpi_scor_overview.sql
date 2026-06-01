/*
Purpose:    IDL-KPI考核得分概览
Creater:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mc_kpi_scor_overview
CreateDate: None
FileType:   DML
Logs:
    表英文名： mc_kpi_scor_overview
    表中文名： KPI考核得分概览
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
        2026-01-21    郑沛隆    新建脚本    
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
alter table ${idl_schema}.mc_kpi_scor_overview add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));
alter table ${idl_schema}.mc_kpi_scor_overview truncate partition p_${batch_date};

whenever sqlerror exit sql.sqlcode; 

/*==============第1组==============*/

--临时表01:获取补录数据
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_kpi_scor_overview_01 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_kpi_scor_overview_01
as
select
    T1.SEQ_NUM as seq_num                                        --None
    ,TO_CHAR(T1.ETL_DT,'yyyy') as asses_year                     --None
    ,t2.ORG_LEVEL as org_type                                    --None
    ,t2.SUPER_ORG_ID as sup_org_no                               --None
    ,t2.org_no as org_no                                         --None
    -- 5
    ,t2.org_name as org_name                                     --None
    ,t1.INDEX_NAME as ind_name                                   --None
    ,t1.IND_SCOR as ind_scor                                     --None
    ,t3.STD_SCOR as std_scor                                     --None
    ,t3.SCOR_UPLMI as scor_uplmi                                 --None
    -- 10
    ,t3.SCOR_LOLMI as scor_lolmi                                 --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_kpi_scor_overview_bl t1 --KPI考核得分概览补录表 
LEFT JOIN mc_orga_para_jxkh t2 --绩效考核机构表 
 on t1.org_no=t2.org_no
and t2.org_level in ('分行','事业部','条线管理部门')
LEFT JOIN (select etl_dt
      ,org_no
      ,sup_ind_name
      ,sum(std_scor) as std_scor
      ,sum(scor_uplmi) as scor_uplmi
      ,sum(scor_lolmi) as scor_lolmi
  from mc_kpi_asses_scor_jg_dtl
 group by etl_dt
         ,org_no
         ,sup_ind_name) t3 --KPI考核得分明细 
 on t1.org_no=t3.org_no
and t1.etl_dt=t3.etl_dt
and t1.index_name=t3.sup_ind_name
where t1.etl_dt=to_date('${batch_date}','yyyymmdd')
 ;
commit;


/*==============第2组==============*/

--临时表02:获取系统数据
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_kpi_scor_overview_02 purge;
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_mc_kpi_scor_overview_02
as
select
    rank () over(partition by t1.org_no order by to_number(case when t3.zbmc='总分' then '0' else t4.xh end)) as seq_num --None
    ,to_char(t5.khnf) as asses_year                              --None
    ,t1.org_level as org_type                                    --None
    ,t1.super_org_id as sup_org_no                               --None
    ,t1.org_no as org_no                                         --None
    -- 5
    ,t1.org_name as org_name                                     --None
    ,t3.zbmc as ind_name                                         --None
    ,t3.khdf as ind_scor                                         --None
    ,t3.bzdf as std_scor                                         --None
    ,t3.dfsx as scor_uplmi                                       --None
    -- 10
    ,t3.dfxx as scor_lolmi                                       --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from mc_orga_para_jxkh t1 --绩效考核机构表 
LEFT JOIN itl_edw_pams_khdx_jg t2 --考核对象-机构 
 on t1.org_no=t2.jgdh
 and t2.etl_dt = to_date('${batch_date}','yyyymmdd')
INNER JOIN itl_edw_pams_jxbb_kpikhdfmx_jg t3 --绩效报表_KPI考核得分明细_机构 
 on t3.tjrq = '${batch_date}'
 and t3.khdxdh = t2.khdxdh
INNER JOIN (select regexp_substr(index_no,'fabh:(\d+)',1,1,null,1) as fabh,
          regexp_substr(index_no,'xh:(\d+)',1,1,null,1) as xh,
          index_name
  from mc_asses_index_define
 where etl_dt = to_date('${batch_date}','yyyymmdd')
       and super_index_no_mcs is null
       and module_name = 'KPI得分情况'
group by regexp_substr(index_no,'fabh:(\d+)',1,1,null,1) ,
          regexp_substr(index_no,'xh:(\d+)',1,1,null,1) ,
          index_name) t4 --考核模块指标定义表 
 on t3.fabh=t4.fabh
 and t3.xh=t4.xh
INNER JOIN itl_edw_pams_khfa_level_manage t5 --考核方案层级管理 
 on t3.fabh=t5.fabh
 and t3.xh=t5.xh
 and t5.etl_dt = to_date('${batch_date}','yyyymmdd')
where t1.org_level in ('分行', '条线管理部门', '事业部')
 and t1.remark is not null
 ;
commit;


/*==============第3组==============*/

--KPI考核得分概览:插入目标表
insert into ${idl_schema}.mc_kpi_scor_overview(
    seq_num                                                      --序号
    ,asses_year                                                  --考核年份
    ,org_type                                                    --机构类型(分行,事业部，支行，团队，客户经理）
    ,sup_org_no                                                  --上级机构编号
    ,org_no                                                      --机构编号
    -- 5
    ,org_name                                                    --机构名称
    ,ind_name                                                    --指标名称
    ,ind_scor                                                    --指标得分
    ,std_scor                                                    --标准得分
    ,scor_uplmi                                                  --得分上限
    -- 10
    ,scor_lolmi                                                  --得分下限
    ,last_mon_val                                                --上月值
    ,rate_last_month                                             --较上月变动
    ,rate_last_month_per                                         --较上月变动百分比
    ,etl_dt                                                      --ETL处理日期
    -- 15
    ,etl_timestamp                                               --ETL处理时间戳
)
select
    coalesce(t2.seq_num,t1.seq_num) as seq_num                   --None
    ,coalesce(t2.asses_year,t1.asses_year) as asses_year         --None
    ,coalesce(t2.org_type,t1.org_type) as org_type               --None
    ,coalesce(t2.sup_org_no,t1.sup_org_no) as sup_org_no         --None
    ,coalesce(t2.org_no,t1.org_no) as org_no                     --None
    -- 5
    ,coalesce(t2.org_name,t1.org_name) as org_name               --None
    ,coalesce(t2.ind_name,t1.ind_name) as ind_name               --None
    ,coalesce(t2.ind_scor,t1.ind_scor) as ind_scor               --None
    ,coalesce(t2.std_scor,t1.std_scor) as std_scor               --None
    ,coalesce(t2.scor_uplmi,t1.scor_uplmi) as scor_uplmi         --None
    -- 10
    ,coalesce(t2.scor_lolmi,t1.scor_lolmi) as scor_lolmi         --None
    ,t3.IND_SCOR as last_mon_val                                 --None
    ,coalesce(t2.ind_scor,t1.ind_scor)-t3.IND_SCOR as rate_last_month --None
    ,case when nvl(t3.IND_SCOR,0)=0 then 0 else (coalesce(t2.ind_scor,t1.ind_scor)-t3.IND_SCOR)/t3.IND_SCOR end as rate_last_month_per --None
    ,to_date('${batch_date}','yyyymmdd') as etl_dt               --None
    -- 15
    ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --None
 from tmp_mc_kpi_scor_overview_02 t1 --临时表02 
FULL JOIN tmp_mc_kpi_scor_overview_01 t2 --临时表01 
 on t1.asses_year=t2.asses_year
 and t1.org_no=t2.org_no
 and t1.ind_name=t2.ind_name
 and t1.etl_dt = t2.etl_dt
LEFT JOIN mc_kpi_scor_overview t3 --None 
 on t3.etl_dt=to_date('${last_month_end}','yyyymmdd')
 and t3.org_no=coalesce(t2.org_no,t1.org_no)
 and t3.ind_name=coalesce(t2.ind_name,t1.ind_name)

where t1.etl_dt = to_date('${batch_date}','yyyymmdd') 
 or t2.etl_dt = to_date('${batch_date}','yyyymmdd')
 
;
commit;

--delete tmp table
whenever sqlerror continue none;
drop table ${idl_schema}.tmp_mc_kpi_scor_overview_01 purge;
drop table ${idl_schema}.tmp_mc_kpi_scor_overview_02 purge;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_kpi_scor_overview', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cAScade => true);
