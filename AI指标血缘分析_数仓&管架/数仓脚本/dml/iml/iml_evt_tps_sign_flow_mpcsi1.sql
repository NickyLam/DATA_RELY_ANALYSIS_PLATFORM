/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tps_sign_flow_mpcsi1
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
drop table ${iml_schema}.evt_tps_sign_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_tps_sign_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tps_sign_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tps_sign_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,broker_secu_cap_acct_id -- 券商证券资金账户编号
    ,broker_cd -- 券商代码
    ,broker_name -- 券商名称
    ,tps_bank_cd -- 第三方存管银行代码
    ,tps_sign_src_cd -- 第三方存管签约来源代码
    ,sign_status_cd -- 签约成功标志
    ,sign_dt -- 签约日期
    ,sign_attach_info -- 签约补充信息
    ,acct_id -- 账户编号
    ,curr_cd -- 币种代码
    ,cust_cert_type_cd -- 客户证件类型代码
    ,cust_cert_no -- 客户证件号码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_org_id -- 开户机构编号
    ,operr_name -- 经办人姓名
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号码
    ,org_id -- 机构编号
    ,org_name -- 机构名称
    ,this_sign_flg -- 签署标志
    ,this_sign_dt -- 签署日期
    ,this_sign_flow_num -- 签署流水号
    ,this_sign_agt_edit_num -- 签署协议版本号
    ,this_sign_agt_src_cd -- 签署协议来源代码
    ,this_sign_ip -- 签署IP
    ,this_sign_mac_addr -- 签署MAC地址
    ,this_sign_equip_model -- 签署设备型号
    ,argue_way_cd -- 争议解决方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_tps_sign_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a35tassignconfirm-1
insert into ${iml_schema}.evt_tps_sign_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,broker_secu_cap_acct_id -- 券商证券资金账户编号
    ,broker_cd -- 券商代码
    ,broker_name -- 券商名称
    ,tps_bank_cd -- 第三方存管银行代码
    ,tps_sign_src_cd -- 第三方存管签约来源代码
    ,sign_status_cd -- 签约成功标志
    ,sign_dt -- 签约日期
    ,sign_attach_info -- 签约补充信息
    ,acct_id -- 账户编号
    ,curr_cd -- 币种代码
    ,cust_cert_type_cd -- 客户证件类型代码
    ,cust_cert_no -- 客户证件号码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type_cd -- 客户类型代码
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_org_id -- 开户机构编号
    ,operr_name -- 经办人姓名
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号码
    ,org_id -- 机构编号
    ,org_name -- 机构名称
    ,this_sign_flg -- 签署标志
    ,this_sign_dt -- 签署日期
    ,this_sign_flow_num -- 签署流水号
    ,this_sign_agt_edit_num -- 签署协议版本号
    ,this_sign_agt_src_cd -- 签署协议来源代码
    ,this_sign_ip -- 签署IP
    ,this_sign_mac_addr -- 签署MAC地址
    ,this_sign_equip_model -- 签署设备型号
    ,argue_way_cd -- 争议解决方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104030'||P1.ACCTNO||P1.SECCD||P1.CAPITALACCTNO||P1.CONFIRMSTATUS -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CAPITALACCTNO -- 券商证券资金账户编号
    ,P1.SECCD -- 券商代码
    ,P1.SECNAME -- 券商名称
    ,decode(P1.COBANK,'0','301','1','307','','-',P1.COBANK) -- 第三方存管银行代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL  ELSE '@'||P1.SIGN_SOURCE END -- 第三方存管签约来源代码
    ,nvl(trim(P1.CONFIRMSTATUS),'-') -- 签约成功标志
    ,${iml_schema}.dateformat_max2(P1.SIGNTM) -- 签约日期
    ,P1.RSPMSG -- 签约补充信息
    ,P1.ACCTNO -- 账户编号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,nvl(trim(P1.IDTYPE),'0000') -- 客户证件类型代码
    ,P1.IDNO -- 客户证件号码
    ,P1.CUSTNO -- 客户编号
    ,P1.CUSTNAME -- 客户名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CUSTTYPE END -- 客户类型代码
    ,P1.CUSTMANAGERID -- 客户经理编号
    ,P1.OPENBRCNO -- 开户机构编号
    ,P1.BIZAGTNAME -- 经办人姓名
    ,nvl(trim(P1.BIZAGTIDTYPE),'0000') -- 经办人证件类型代码
    ,P1.BIZAGTIDNO -- 经办人证件号码
    ,P1.BRCNO -- 机构编号
    ,P1.BRCNAME -- 机构名称
    ,nvl(trim(P1.ISSIGN),'-') -- 签署标志
    ,${iml_schema}.dateformat_max2(P1.SIGNDATE) -- 签署日期
    ,P1.SIGNSEQNO -- 签署流水号
    ,P1.TREATY_VERSION -- 签署协议版本号
    ,nvl(trim(P1.TREATY_SOURCE),'-') -- 签署协议来源代码
    ,P1.SIGN_IP -- 签署IP
    ,P1.SIGN_MAC -- 签署MAC地址
    ,P1.SIGN_TYPE -- 签署设备型号
    ,nvl(trim(P1.ARGUE_DEALWAY),'-') -- 争议解决方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a35tassignconfirm' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a35tassignconfirm p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SIGN_SOURCE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A35TASSIGNCONFIRM'
        AND R1.SRC_FIELD_EN_NAME= 'SIGN_SOURCE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TPS_SIGN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TPS_SIGN_SRC_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CUSTTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A35TASSIGNCONFIRM'
        AND R2.SRC_FIELD_EN_NAME= 'CUSTTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_TPS_SIGN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_tps_sign_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_tps_sign_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_tps_sign_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tps_sign_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_tps_sign_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tps_sign_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);