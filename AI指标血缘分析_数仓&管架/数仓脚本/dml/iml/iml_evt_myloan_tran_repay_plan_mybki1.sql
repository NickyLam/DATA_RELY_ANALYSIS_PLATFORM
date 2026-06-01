/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_myloan_tran_repay_plan_mybki1
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
drop table ${iml_schema}.evt_myloan_tran_repay_plan_mybki1_tm purge;
alter table ${iml_schema}.evt_myloan_tran_repay_plan add partition p_mybki1 values ('mybki1')(
        subpartition p_mybki1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_myloan_tran_repay_plan modify partition p_mybki1
    add subpartition p_mybki1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_myloan_tran_repay_plan_mybki1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,pd_num -- 期次号
    ,asset_tran_bus_dt -- 资产转让业务日期
    ,asset_tran_tran_tm -- 资产转让交易时间
    ,asset_tran_bus_flow_num -- 资产转让业务流水号
    ,cap_flow_num -- 资金流水号
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,tran_type_cd -- 转让类型代码
    ,tran_way_cd -- 转让方式代码
    ,tran_amt -- 转让金额
    ,asset_bal_diff_amt -- 作价资产余额和转让金额差价
    ,inst_status_cd -- 分期状态代码
    ,acru_non_idf_cd -- 应计非应计标识代码
    ,wrt_off_flg -- 核销标志
    ,asset_tran_cntpty_org_id -- 资产转让交易对手机构编号
    ,dist_cd -- 行政区划代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_myloan_tran_repay_plan
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_mybk_asset_transfer_detail-1
insert into ${iml_schema}.evt_myloan_tran_repay_plan_mybki1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,pd_num -- 期次号
    ,asset_tran_bus_dt -- 资产转让业务日期
    ,asset_tran_tran_tm -- 资产转让交易时间
    ,asset_tran_bus_flow_num -- 资产转让业务流水号
    ,cap_flow_num -- 资金流水号
    ,inst_start_dt -- 分期开始日期
    ,inst_end_dt -- 分期结束日期
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,tran_type_cd -- 转让类型代码
    ,tran_way_cd -- 转让方式代码
    ,tran_amt -- 转让金额
    ,asset_bal_diff_amt -- 作价资产余额和转让金额差价
    ,inst_status_cd -- 分期状态代码
    ,acru_non_idf_cd -- 应计非应计标识代码
    ,wrt_off_flg -- 核销标志
    ,asset_tran_cntpty_org_id -- 资产转让交易对手机构编号
    ,dist_cd -- 行政区划代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102003'||TO_CHAR(P1.TERMNO)||substr(P1.SETTLEDATE,1,8)||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CONTRACTNO -- 合同编号
    ,TO_CHAR(P1.TERMNO) -- 期次号
    ,${iml_schema}.dateformat_max2(P1.SETTLEDATE) -- 资产转让业务日期
    ,${iml_schema}.TIMEFORMAT_MAX(P1.TRANSTIME) -- 资产转让交易时间
    ,P1.SEQNO -- 资产转让业务流水号
    ,P1.FUNDSEQNO -- 资金流水号
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 分期开始日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 分期结束日期
    ,nvl(trim(P1.PRINBAL),0) -- 本金余额
    ,nvl(trim(P1.INTBAL),0) -- 利息余额
    ,nvl(trim(P1.OVDPRINPNLTBAL),0) -- 逾期本金罚息余额
    ,nvl(trim(P1.OVDINTPNLTBAL),0) -- 逾期利息罚息余额
    ,NVL(TRIM(P1.OPTTYPE),'-') -- 转让类型代码
    ,P1.FVTPLTAG -- 转让方式代码
    ,nvl(trim(P1.CLEARINGAMT),0) -- 转让金额
    ,nvl(trim(P1.DIFFAMT),0) -- 作价资产余额和转让金额差价
    ,P1.STATUS -- 分期状态代码
    ,P1.ACCRUEDSTATUS -- 应计非应计标识代码
    ,P1.WRITEOFF -- 核销标志
    ,P1.OPSTORG -- 资产转让交易对手机构编号
    ,P1.REGIONCODE -- 行政区划代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_asset_transfer_detail' -- 源表名称
    ,'mybki1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybk_asset_transfer_detail p1
where  1 = 1 
    and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_myloan_tran_repay_plan truncate subpartition p_mybki1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_myloan_tran_repay_plan exchange subpartition p_mybki1_${batch_date} with table ${iml_schema}.evt_myloan_tran_repay_plan_mybki1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_myloan_tran_repay_plan to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_myloan_tran_repay_plan_mybki1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_myloan_tran_repay_plan', partname => 'p_mybki1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);