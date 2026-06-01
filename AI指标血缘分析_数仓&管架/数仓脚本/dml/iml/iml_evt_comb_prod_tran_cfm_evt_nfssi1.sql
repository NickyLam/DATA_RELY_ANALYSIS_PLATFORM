/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_comb_prod_tran_cfm_evt_nfssi1
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
drop table ${iml_schema}.evt_comb_prod_tran_cfm_evt_nfssi1_tm purge;
alter table ${iml_schema}.evt_comb_prod_tran_cfm_evt add partition p_nfssi1 values ('nfssi1')(
        subpartition p_nfssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_comb_prod_tran_cfm_evt modify partition p_nfssi1
    add subpartition p_nfssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_comb_prod_tran_cfm_evt_nfssi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,ta_cd -- TA代码
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_dt -- 确认日期
    ,comb_prod_id -- 组合产品编号
    ,comb_prod_name -- 组合产品名称
    ,finc_prod_id -- 理财产品编号
    ,bank_id -- 银行编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ext_flow_num -- 外部流水号
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,tran_cd -- 交易代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,tran_lot -- 交易份额
    ,tran_tm -- 交易时间
    ,cfm_amt -- 确认金额
    ,cfm_lot -- 确认份额
    ,cfm_comm_fee -- 确认手续费
    ,cfm_nv -- 确认净值
    ,bus_cd -- 业务代码
    ,intior_cd -- 发起方代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,divd_dt -- 分红日期
    ,rgst_dt -- 登记日期
    ,modif_tm -- 修改时间
    ,return_amt -- 返回金额
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_comb_prod_tran_cfm_evt
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- nfss_hstctrans1_v_tbgrpprdtranscfm-1
insert into ${iml_schema}.evt_comb_prod_tran_cfm_evt_nfssi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,ta_cd -- TA代码
    ,ta_cfm_flow_num -- TA确认流水号
    ,cfm_dt -- 确认日期
    ,comb_prod_id -- 组合产品编号
    ,comb_prod_name -- 组合产品名称
    ,finc_prod_id -- 理财产品编号
    ,bank_id -- 银行编号
    ,bank_acct_id -- 银行账户编号
    ,prod_type_cd -- 产品类型代码
    ,ext_flow_num -- 外部流水号
    ,intnal_cust_id -- 内部客户编号
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,vtual_bank_acct_id -- 虚拟银行账户编号
    ,tran_cd -- 交易代码
    ,tran_status_cd -- 交易状态代码
    ,tran_amt -- 交易金额
    ,tran_lot -- 交易份额
    ,tran_tm -- 交易时间
    ,cfm_amt -- 确认金额
    ,cfm_lot -- 确认份额
    ,cfm_comm_fee -- 确认手续费
    ,cfm_nv -- 确认净值
    ,bus_cd -- 业务代码
    ,intior_cd -- 发起方代码
    ,deflt_divd_way_cd -- 默认分红方式代码
    ,divd_dt -- 分红日期
    ,rgst_dt -- 登记日期
    ,modif_tm -- 修改时间
    ,return_amt -- 返回金额
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401024'||SERIAL_NO||P1.CFM_DATE||P1.CFM_NO||P1.TA_CODE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIAL_NO -- 流水号
    ,nvl(trim(P1.TA_CODE),'_') -- TA代码
    ,P1.CFM_NO -- TA确认流水号
    ,${iml_schema}.dateformat_max2(P1.CFM_DATE) -- 确认日期
    ,P1.GROUP_CODE -- 组合产品编号
    ,P1.GROUP_NAME -- 组合产品名称
    ,P1.PRD_CODE -- 理财产品编号
    ,P1.BANK_NO -- 银行编号
    ,P1.BANK_ACC -- 银行账户编号
    ,nvl(trim(P1.PRD_TYPE),'_') -- 产品类型代码
    ,P1.EX_SERIAL -- 外部流水号
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,P1.CLIENT_NO -- 客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE end -- 客户类型代码
    ,P1.VIRTUAL_BANK_ACC -- 虚拟银行账户编号
    ,nvl(trim(P1.TRANS_CODE),'_') -- 交易代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||p1.STATUS END -- 交易状态代码
    ,P1.AMT -- 交易金额
    ,P1.VOL -- 交易份额
    ,${iml_schema}.timeformat_max(P1.TRANS_DATE||P1.TRANS_TIME) -- 交易时间
    ,P1.CFM_AMT -- 确认金额
    ,P1.CFM_VOL -- 确认份额
    ,P1.CFM_FEE -- 确认手续费
    ,P1.CFM_NAV -- 确认净值
    ,nvl(trim(P1.BUSIN_CODE),'_') -- 业务代码
    ,nvl(trim(P1.FROM_FLAG),'_') -- 发起方代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||p1.DIV_MODE END -- 默认分红方式代码
    ,${iml_schema}.dateformat_max2(P1.DIV_DATE) -- 分红日期
    ,${iml_schema}.dateformat_min(P1.REG_DATE) -- 登记日期
    ,${iml_schema}.timeformat_max(P1.MODIFY_TIMESTAMP) -- 修改时间
    ,P1.BACK_AMT -- 返回金额
    ,P1.ERR_CODE -- 错误码
    ,P1.ERR_MSG -- 错误信息描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_hstctrans1_v_tbgrpprdtranscfm' -- 源表名称
    ,'nfssi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NFSS'
        AND R1.SRC_TAB_EN_NAME= 'NFSS_HSTCTRANS1_V_TBGRPPRDTRANSCFM'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_COMB_PROD_TRAN_CFM_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STATUS= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NFSS'
        AND R2.SRC_TAB_EN_NAME= 'NFSS_HSTCTRANS1_V_TBGRPPRDTRANSCFM'
        AND R2.SRC_FIELD_EN_NAME= 'STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_COMB_PROD_TRAN_CFM_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.DIV_MODE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NFSS'
        AND R3.SRC_TAB_EN_NAME= 'NFSS_HSTCTRANS1_V_TBGRPPRDTRANSCFM'
        AND R3.SRC_FIELD_EN_NAME= 'DIV_MODE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_COMB_PROD_TRAN_CFM_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'DEFLT_DIVD_WAY_CD'
 where  1 = 1 
  and p1.etl_dt = to_Date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_comb_prod_tran_cfm_evt truncate subpartition p_nfssi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_comb_prod_tran_cfm_evt exchange subpartition p_nfssi1_${batch_date} with table ${iml_schema}.evt_comb_prod_tran_cfm_evt_nfssi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_comb_prod_tran_cfm_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_comb_prod_tran_cfm_evt_nfssi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_comb_prod_tran_cfm_evt', partname => 'p_nfssi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);