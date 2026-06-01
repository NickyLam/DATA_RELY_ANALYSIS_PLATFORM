/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wyd_out_acct_appl_icmsf1
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
drop table ${iml_schema}.agt_wyd_out_acct_appl_icmsf1_tm purge;
alter table ${iml_schema}.agt_wyd_out_acct_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wyd_out_acct_appl modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_out_acct_appl_icmsf1_tm
compress ${option_switch} for query high
as
select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,out_acct_flow_num -- 出账流水号
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,mercht_id -- 商户编号
    ,bus_lics_id -- 营业执照编号
    ,corp_size_cd -- 企业规模代码
    ,eigen_code -- 中征码
    ,tel_num -- 联系号码
    ,appl_tm -- 申请时间
    ,appl_site -- 申请地点
    ,appl_usage_cd -- 申请用途代码
    ,precon_distr_dt -- 预约放款日期
    ,tran_status_cd -- 交易状态代码
    ,cont_amt -- 合同金额
    ,exp_dt -- 到期日期
    ,intnal_rating_cd -- 内部评级代码
    ,risk_mgmt_return_dt -- 风控返回日期
    ,lp_crdtc_auth_sign_dt -- 法人征信授权书签署日期
    ,lp_crdtc_auth_sign_flow_num -- 法人征信授权书签署流水号
    ,crdtc_rest_cd -- 征信检验结果代码
    ,init_dubil_id -- 原借据编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_org_id -- 客户经理机构编号
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
from ${iml_schema}.agt_wyd_out_acct_appl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wyd_putout_apply-1
insert into ${iml_schema}.agt_wyd_out_acct_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,out_acct_flow_num -- 出账流水号
    ,prod_id -- 产品编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,mercht_id -- 商户编号
    ,bus_lics_id -- 营业执照编号
    ,corp_size_cd -- 企业规模代码
    ,eigen_code -- 中征码
    ,tel_num -- 联系号码
    ,appl_tm -- 申请时间
    ,appl_site -- 申请地点
    ,appl_usage_cd -- 申请用途代码
    ,precon_distr_dt -- 预约放款日期
    ,tran_status_cd -- 交易状态代码
    ,cont_amt -- 合同金额
    ,exp_dt -- 到期日期
    ,intnal_rating_cd -- 内部评级代码
    ,risk_mgmt_return_dt -- 风控返回日期
    ,lp_crdtc_auth_sign_dt -- 法人征信授权书签署日期
    ,lp_crdtc_auth_sign_flow_num -- 法人征信授权书签署流水号
    ,crdtc_rest_cd -- 征信检验结果代码
    ,init_dubil_id -- 原借据编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_org_id -- 客户经理机构编号
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
    '206011'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.BRNO -- 机构编号
    ,P1.SEQNO -- 出账流水号
    ,P1.PRODUCTID -- 产品编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CORPNAME -- 客户名称
    ,P1.MERCHANTNO -- 商户编号
    ,P1.BUSILICENSEID -- 营业执照编号
    ,case when trim(P1.ENTSCALE) is not null then nvl(trim(P1.ENTSCALE),'0')  
 else decode(trim(P1.BUSSCALE),'5','9','','-',P1.BUSSCALE) end -- 企业规模代码
    ,P1.ZZM -- 中征码
    ,P1.TELNO -- 联系号码
    ,P1.APPLYTIME -- 申请时间
    ,P1.APPAREA -- 申请地点
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.APPUSE END -- 申请用途代码
    ,${iml_schema}.dateformat_max2(regexp_replace(APPOINTDATE,'[^0-9.]','')) -- 预约放款日期
    ,nvl(trim（P1.TRANSSTATUS),'-') -- 交易状态代码
    ,P1.PACTAMT -- 合同金额
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 到期日期
    ,nvl(trim（P1.CUSTLEVEL),'-') -- 内部评级代码
    ,P1.FKRELEASETIME -- 风控返回日期
    ,P1.SIGNINGPERSONAUTHTIME -- 法人征信授权书签署日期
    ,P1.SIGNINGPERSONAUTHSEQ -- 法人征信授权书签署流水号
    ,nvl(trim（P1.ZHENGXINCHECKRESULT),'-') -- 征信检验结果代码
    ,P1.LOANACCTNO -- 原借据编号
    ,P1.MANAGEUSERID -- 客户经理编号
    ,P1.MANAGEORGID -- 客户经理机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记所属机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wyd_putout_apply' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wyd_putout_apply p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.APPUSE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_WYD_PUTOUT_APPLY'
        AND R1.SRC_FIELD_EN_NAME= 'APPUSE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WYD_OUT_ACCT_APPL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'APPL_USAGE_CD'
where  1 = 1 
    and p1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_wyd_out_acct_appl truncate subpartition p_icmsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_wyd_out_acct_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wyd_out_acct_appl_icmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wyd_out_acct_appl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wyd_out_acct_appl_icmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wyd_out_acct_appl', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);