/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_qxb_prod_nv_fsmsi1
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
drop table ${iml_schema}.prd_qxb_prod_nv_fsmsi1_tm purge;
alter table ${iml_schema}.prd_qxb_prod_nv add partition p_fsmsi1 values ('fsmsi1')(
        subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_qxb_prod_nv modify partition p_fsmsi1
    add subpartition p_fsmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_qxb_prod_nv_fsmsi1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,qxb_fund_prod_id -- 七兴宝基金产品编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,nv_dt -- 净值日期
    ,issue_dt -- 发布日期
    ,td_prod_status_cd -- 当日产品状态代码
    ,td_tot_lot -- 当日总份额
    ,td_prod_nv -- 当日产品净值
    ,acm_nv -- 累计净值
    ,curr_fund_aual_yld -- 货币基金年化收益率
    ,curr_fund_sevn_aual_yld -- 货币基金七日年化收益率
    ,curr_fund_ten_thous_prft -- 货币基金万份收益
    ,prod_tran_status_cd -- 产品转换状态代码
    ,turn_trust_status_cd -- 转托管状态代码
    ,reg_quota_status_cd -- 定期定额状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_qxb_prod_nv
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fsms_yeb_cfg_nav-1
insert into ${iml_schema}.prd_qxb_prod_nv_fsmsi1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,qxb_fund_prod_id -- 七兴宝基金产品编号
    ,ibank_no -- 联行号
    ,ta_cd -- TA代码
    ,sell_mode_cd -- 销售模式代码
    ,nv_dt -- 净值日期
    ,issue_dt -- 发布日期
    ,td_prod_status_cd -- 当日产品状态代码
    ,td_tot_lot -- 当日总份额
    ,td_prod_nv -- 当日产品净值
    ,acm_nv -- 累计净值
    ,curr_fund_aual_yld -- 货币基金年化收益率
    ,curr_fund_sevn_aual_yld -- 货币基金七日年化收益率
    ,curr_fund_ten_thous_prft -- 货币基金万份收益
    ,prod_tran_status_cd -- 产品转换状态代码
    ,turn_trust_status_cd -- 转托管状态代码
    ,reg_quota_status_cd -- 定期定额状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222007' -- 产品编号
    ,'9999' -- 法人编号
    ,trim(P1.FUNDCODE) -- 七兴宝基金产品编号
    ,TRIM(P1.UNIONCODE) -- 联行号
    ,trim(P1.TANO) -- TA代码
    ,nvl(trim(P1.TASYSMODEL),'-') -- 销售模式代码
    ,P1.NAVDATE -- 净值日期
    ,P1.BULLETINDATE -- 发布日期
    ,P1.STATUS -- 当日产品状态代码
    ,P1.FOTALFUNDVOL -- 当日总份额
    ,P1.NAV -- 当日产品净值
    ,P1.TOTALNAV -- 累计净值
    ,P1.FUNDYEARINCOMERATE -- 货币基金年化收益率
    ,P1.YIELD -- 货币基金七日年化收益率
    ,P1.FUNDINCOME -- 货币基金万份收益
    ,P1.CONVERTSTATUS -- 产品转换状态代码
    ,P1.TRANSFERAGENCYSTATUS -- 转托管状态代码
    ,P1.PERIODICSTATUS -- 定期定额状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_yeb_cfg_nav' -- 源表名称
    ,'fsmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_yeb_cfg_nav p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and P1.START_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.prd_qxb_prod_nv truncate subpartition p_fsmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_qxb_prod_nv exchange subpartition p_fsmsi1_${batch_date} with table ${iml_schema}.prd_qxb_prod_nv_fsmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_qxb_prod_nv to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_qxb_prod_nv_fsmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_qxb_prod_nv', partname => 'p_fsmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);