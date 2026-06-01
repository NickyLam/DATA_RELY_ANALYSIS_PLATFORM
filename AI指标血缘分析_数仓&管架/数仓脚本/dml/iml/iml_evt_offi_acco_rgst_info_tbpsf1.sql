/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_offi_acco_rgst_info_tbpsf1
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
drop table ${iml_schema}.evt_offi_acco_rgst_info_tbpsf1_tm purge;
alter table ${iml_schema}.evt_offi_acco_rgst_info add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_offi_acco_rgst_info modify partition p_tbpsf1
    add subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_offi_acco_rgst_info_tbpsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,offi_acco_user_idf -- 公众号用户标识
    ,offi_acco_type_cd -- 公众号类型代码
    ,bind_status_cd -- 绑定状态代码
    ,fir_bind_dt -- 首次绑定日期
    ,bind_chn_cd -- 绑定渠道代码
    ,repl_dsply_flg -- 切换显示标志
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,operr_id -- 操作员编号
    ,operr_name -- 操作员姓名
    ,operr_tel_num -- 操作员电话号码
    ,corp_cust_id -- 企业客户编号
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_offi_acco_rgst_info
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- tbps_cpr_wx_bindinf-1
insert into ${iml_schema}.evt_offi_acco_rgst_info_tbpsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,offi_acco_user_idf -- 公众号用户标识
    ,offi_acco_type_cd -- 公众号类型代码
    ,bind_status_cd -- 绑定状态代码
    ,fir_bind_dt -- 首次绑定日期
    ,bind_chn_cd -- 绑定渠道代码
    ,repl_dsply_flg -- 切换显示标志
    ,acct_id -- 账户编号
    ,acct_type_cd -- 账户类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,operr_id -- 操作员编号
    ,operr_name -- 操作员姓名
    ,operr_tel_num -- 操作员电话号码
    ,corp_cust_id -- 企业客户编号
    ,corp_cert_type_cd -- 企业证件类型代码
    ,corp_cert_no -- 企业证件号码
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401055'||P1.CWB_OPENID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CWB_OPENID -- 公众号用户标识
    ,nvl(trim(P1.CWB_OPENACC),'-') -- 公众号类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CWB_BINDSTATUS END -- 绑定状态代码
    ,${iml_schema}.dateformat_min(P1.CWB_FIRSTTIME) -- 首次绑定日期
    ,decode(P1.CWB_CHANNEL,'GSW','','2','WBS','1',' ','-',P1.CWB_CHANNEL) -- 绑定渠道代码
    ,P1.CWB_SHOW -- 切换显示标志
    ,P1.CWB_ACCNO -- 账户编号
    ,nvl(trim(P1.CWB_ACCTYPE),'-') -- 账户类型代码
    ,nvl(trim(P1.CWB_USERCTFTYPE),'0000') -- 证件类型代码
    ,P1.CWB_USERCTFNO -- 证件号码
    ,P1.CWB_USERNO -- 操作员编号
    ,P1.CWB_USERNAME -- 操作员姓名
    ,P1.CWB_PHONE -- 操作员电话号码
    ,P1.CWB_CSTNO -- 企业客户编号
    ,nvl(trim(P1.CWB_CTFTYPE),'0000') -- 企业证件类型代码
    ,P1.CWB_CTFNO -- 企业证件号码
    ,${iml_schema}.dateformat_max2(P1.CWB_UPDATETIME) -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_wx_bindinf' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_wx_bindinf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CWB_BINDSTATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'TBPS'
        AND R1.SRC_TAB_EN_NAME= 'TBPS_CPR_WX_BINDINF'
        AND R1.SRC_FIELD_EN_NAME= 'CWB_BINDSTATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_OFFI_ACCO_RGST_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BIND_STATUS_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_offi_acco_rgst_info truncate partition p_tbpsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_offi_acco_rgst_info exchange subpartition p_tbpsf1_${batch_date} with table ${iml_schema}.evt_offi_acco_rgst_info_tbpsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_offi_acco_rgst_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_offi_acco_rgst_info_tbpsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_offi_acco_rgst_info', partname => 'p_tbpsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);