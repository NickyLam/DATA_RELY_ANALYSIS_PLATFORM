/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wyd_repay_dtl_icmsi1
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
drop table ${iml_schema}.evt_wyd_repay_dtl_icmsi1_tm purge;
alter table ${iml_schema}.evt_wyd_repay_dtl add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wyd_repay_dtl modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wyd_repay_dtl_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,cont_id -- 合同编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,repay_pric -- 还款本金
    ,repay_int -- 还款利息
    ,repay_pnlt -- 还款罚息
    ,repay_fee -- 还款费用
    ,repay_type_cd -- 还款类型代码
    ,repay_dt -- 还款日期
    ,in_bs_int -- 表内利息
    ,in_bs_pnlt -- 表内罚息
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wyd_repay_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wyd_payment_detail-1
insert into ${iml_schema}.evt_wyd_repay_dtl_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,cont_id -- 合同编号
    ,dubil_id -- 借据编号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,repay_pric -- 还款本金
    ,repay_int -- 还款利息
    ,repay_pnlt -- 还款罚息
    ,repay_fee -- 还款费用
    ,repay_type_cd -- 还款类型代码
    ,repay_dt -- 还款日期
    ,in_bs_int -- 表内利息
    ,in_bs_pnlt -- 表内罚息
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401048'||P1.REFNO||P1.TRANSDATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.REFNO -- 还款流水号
    ,P1.CONTRACTNO -- 合同编号
    ,P1.LENDINGREF -- 借据编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim（P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,P1.PPAY -- 还款本金
    ,P1.IPAY -- 还款利息
    ,P1.PPPAY -- 还款罚息
    ,P1.FEEREPAY -- 还款费用
    ,nvl(trim（P1.TYPE),'-') -- 还款类型代码
    ,${iml_schema}.dateformat_max2(P1.TRANSDATE) -- 还款日期
    ,P1.IPAYBN -- 表内利息
    ,P1.FPAYBN -- 表内罚息
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记所属机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wyd_payment_detail' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wyd_payment_detail p1
where  1 = 1 
    and p1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wyd_repay_dtl truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wyd_repay_dtl exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_wyd_repay_dtl_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wyd_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wyd_repay_dtl_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wyd_repay_dtl', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);