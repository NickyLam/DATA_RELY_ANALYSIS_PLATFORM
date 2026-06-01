/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bond_issue_tran_dtl_ctmsf1
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
drop table ${iml_schema}.evt_bond_issue_tran_dtl_ctmsf1_tm purge;
alter table ${iml_schema}.evt_bond_issue_tran_dtl add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bond_issue_tran_dtl modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bond_issue_tran_dtl_ctmsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_cd -- 法人代码
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_type_cd -- 债券类型代码
    ,tran_id -- 交易编号
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,tran_dir_cd -- 交易方向代码
    ,tran_net_price -- 交易净价
    ,tran_full_price -- 交易全价
    ,exp_yld_rat -- 到期收益率
    ,stl_amt -- 转贴现金额
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_attr_cd -- 账簿属性代码
    ,asset_cls4_name -- 资产四分类名称
    ,stl_way_cd -- 结算方式代码
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,cert_face_tot -- 券面总额
    ,cfets_tran_flg -- CFETS交易标志
    ,tran_src_cd -- 交易来源代码
    ,asset_type_cd -- 资产类型代码
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,issue_status_cd -- 发行状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bond_issue_tran_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- ctms_tbs_vs_payment_bondspublish-1
insert into ${iml_schema}.evt_bond_issue_tran_dtl_ctmsf1_tm(
    evt_id -- 事件编号
    ,lp_cd -- 法人代码
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_type_cd -- 债券类型代码
    ,tran_id -- 交易编号
    ,tran_dt -- 交易日期
    ,dlvy_dt -- 交割日期
    ,tran_dir_cd -- 交易方向代码
    ,tran_net_price -- 交易净价
    ,tran_full_price -- 交易全价
    ,exp_yld_rat -- 到期收益率
    ,stl_amt -- 转贴现金额
    ,portf_id -- 投组编号
    ,portf_name -- 投组名称
    ,acct_b_id -- 账簿编号
    ,acct_b_name -- 账簿名称
    ,acct_b_attr_cd -- 账簿属性代码
    ,asset_cls4_name -- 资产四分类名称
    ,stl_way_cd -- 结算方式代码
    ,dealer_id -- 交易员编号
    ,dealer_name -- 交易员名称
    ,cert_face_tot -- 券面总额
    ,cfets_tran_flg -- CFETS交易标志
    ,tran_src_cd -- 交易来源代码
    ,asset_type_cd -- 资产类型代码
    ,acpt_pay_cfm_modif_tm -- 收付确认修改时间
    ,issue_status_cd -- 发行状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201008'||TO_CHAR(P1.DEAL_ID) -- 事件编号
    ,'9999' -- 法人代码
    ,TO_CHAR(P1.DEAL_ID) -- 业务编号
    ,P1.DEAL_TABLENAME -- 业务表名称
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,P1.BONDSCODE -- 债券编号
    ,P1.BONDSNAME -- 债券名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BONDSTYPE END -- 债券类型代码
    ,P1.SERIAL_NUMBER -- 交易编号
    ,${iml_schema}.dateformat_min(TO_CHAR(P1.TRADEDATE)) -- 交易日期
    ,${iml_schema}.dateformat_min(TO_CHAR(P1.SETTLEDATE)) -- 交割日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BUYORSELL END -- 交易方向代码
    ,P1.CLEANPRICE -- 交易净价
    ,P1.DIRTYPRICE -- 交易全价
    ,P1.YIELDTOMATURITY -- 到期收益率
    ,P1.SETTLEAMOUNT -- 转贴现金额
    ,TO_CHAR(P1.PORTFOLIO_ID) -- 投组编号
    ,P1.PORTFOLIO_NAME -- 投组名称
    ,TO_CHAR(P1.KEEPFOLDER_ID) -- 账簿编号
    ,P1.KEEPFOLDER_SHORTNAME -- 账簿名称
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.FOLDERATTS END -- 账簿属性代码
    ,P1.CLASSFYNAME -- 资产四分类名称
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.SETTLETYPE END -- 结算方式代码
    ,TO_CHAR(P1.DEALER_ID) -- 交易员编号
    ,P1.DEALER_NAME -- 交易员名称
    ,P1.NOMINAL -- 券面总额
    ,CASE WHEN P1.CFETS_FROM='Y' THEN '1' 
          WHEN P1.CFETS_FROM='N' THEN '0'
     ELSE '-' END -- CFETS交易标志 -- CFETS交易标志
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.SOURCE END -- 交易来源代码
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||TO_CHAR(P1.ASSETTYPE_ID) END -- 资产类型代码
    ,P1.LASTMODIFIED_PAY -- 收付确认修改时间
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 发行状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_bondspublish' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_bondspublish p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BONDSTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'CTMS'
        AND R1.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_BONDSPUBLISH'
        AND R1.SRC_FIELD_EN_NAME= 'BONDSTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BOND_ISSUE_TRAN_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BOND_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BUYORSELL = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'CTMS'
        AND R2.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_BONDSPUBLISH'
        AND R2.SRC_FIELD_EN_NAME= 'BUYORSELL'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_BOND_ISSUE_TRAN_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.FOLDERATTS = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'CTMS'
        AND R3.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_BONDSPUBLISH'
        AND R3.SRC_FIELD_EN_NAME= 'FOLDERATTS'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_BOND_ISSUE_TRAN_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ACCT_B_ATTR_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.SETTLETYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'CTMS'
        AND R5.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_BONDSPUBLISH'
        AND R5.SRC_FIELD_EN_NAME= 'SETTLETYPE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_BOND_ISSUE_TRAN_DTL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.SOURCE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'CTMS'
        AND R6.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_BONDSPUBLISH'
        AND R6.SRC_FIELD_EN_NAME= 'SOURCE'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_BOND_ISSUE_TRAN_DTL'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'TRAN_SRC_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on TO_CHAR(P1.ASSETTYPE_ID) = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'CTMS'
        AND R7.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_BONDSPUBLISH'
        AND R7.SRC_FIELD_EN_NAME= 'ASSETTYPE_ID'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_BOND_ISSUE_TRAN_DTL'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'ASSET_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.STATUS = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'CTMS'
        AND R8.SRC_TAB_EN_NAME= 'CTMS_TBS_VS_PAYMENT_BONDSPUBLISH'
        AND R8.SRC_FIELD_EN_NAME= 'STATUS'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_BOND_ISSUE_TRAN_DTL'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'ISSUE_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_bond_issue_tran_dtl truncate partition p_ctmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bond_issue_tran_dtl exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.evt_bond_issue_tran_dtl_ctmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bond_issue_tran_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bond_issue_tran_dtl_ctmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bond_issue_tran_dtl', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);