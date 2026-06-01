/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tsafebox_swi_dtl_mpcsi1
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
drop table ${iml_schema}.evt_tsafebox_swi_dtl_mpcsi1_tm purge;
alter table ${iml_schema}.evt_tsafebox_swi_dtl add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tsafebox_swi_dtl modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tsafebox_swi_dtl_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,doc_name -- 文件名称
    ,insure_id -- 保险箱编号
    ,rgst_dt -- 登记日期
    ,oper_dt -- 操作日期
    ,operr_name -- 操作人名称
    ,open_box_way_cd -- 开箱方式代码
    ,open_box_dt -- 开箱日期
    ,unpacker_pub_priv_idf_cd -- 开箱人公私标识代码
    ,unpacker_name -- 开箱人姓名
    ,unpacker_id_card_proof -- 开箱人身份证明文件
    ,unpacker_cert_no -- 开箱人证件号码
    ,unpacker_cert_valid_dt -- 开箱人证件有效日期
    ,unpacker_idti_type_cd -- 开箱人身份类型代码
    ,brac_org_id -- 网点机构编号
    ,actl_user_pub_priv_idf_cd -- 实际使用人公私标识代码
    ,actl_user_name -- 实际使用人姓名
    ,actl_user_id_card_proof -- 实际使用人身份证明文件
    ,actl_user_cert_id -- 实际使用人证件编号
    ,actl_user_cert_valid_dt -- 实际使用人证件有效日期
    ,actl_use_cust_id -- 实际使用客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_tsafebox_swi_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a20tsafeboxdetail-1
insert into ${iml_schema}.evt_tsafebox_swi_dtl_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,doc_name -- 文件名称
    ,insure_id -- 保险箱编号
    ,rgst_dt -- 登记日期
    ,oper_dt -- 操作日期
    ,operr_name -- 操作人名称
    ,open_box_way_cd -- 开箱方式代码
    ,open_box_dt -- 开箱日期
    ,unpacker_pub_priv_idf_cd -- 开箱人公私标识代码
    ,unpacker_name -- 开箱人姓名
    ,unpacker_id_card_proof -- 开箱人身份证明文件
    ,unpacker_cert_no -- 开箱人证件号码
    ,unpacker_cert_valid_dt -- 开箱人证件有效日期
    ,unpacker_idti_type_cd -- 开箱人身份类型代码
    ,brac_org_id -- 网点机构编号
    ,actl_user_pub_priv_idf_cd -- 实际使用人公私标识代码
    ,actl_user_name -- 实际使用人姓名
    ,actl_user_id_card_proof -- 实际使用人身份证明文件
    ,actl_user_cert_id -- 实际使用人证件编号
    ,actl_user_cert_valid_dt -- 实际使用人证件有效日期
    ,actl_use_cust_id -- 实际使用客户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401034'||P1.FILENAME||P1.LINENO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.FILENAME -- 文件名称
    ,P1.SAFEBOX -- 保险箱编号
    ,${iml_schema}.dateformat_max2(P1.INSERTDT||P1.INSERTTM) -- 登记日期
    ,${iml_schema}.dateformat_max2(P1.OPERDT) -- 操作日期
    ,P1.OPERNAME -- 操作人名称
    ,nvl(trim(P1.OPENMODE),'-') -- 开箱方式代码
    ,${iml_schema}.dateformat_max2(P1.OPENDATE) -- 开箱日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.OPENPSNFLAG END -- 开箱人公私标识代码
    ,P1.OPENPSNNAME -- 开箱人姓名
    ,P1.OPENPSNIDTP -- 开箱人身份证明文件
    ,P1.OPENPSNIDNO -- 开箱人证件号码
    ,${iml_schema}.dateformat_max2(P1.OPENPSNIDDT) -- 开箱人证件有效日期
    ,nvl(trim(P1.OPENPSNID),'-') -- 开箱人身份类型代码
    ,P1.BRCHNO -- 网点机构编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.USERFLAG END -- 实际使用人公私标识代码
    ,P1.USERNAME -- 实际使用人姓名
    ,P1.USERIDTP -- 实际使用人身份证明文件
    ,P1.USERIDNO -- 实际使用人证件编号
    ,${iml_schema}.dateformat_max2(P1.USERIDDT) -- 实际使用人证件有效日期
    ,P1.USERCUSTNO -- 实际使用客户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a20tsafeboxdetail' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.mpcs_a20tsafeboxdetail p1
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.openpsnflag = r1.src_code_val
   and r1.sorc_sys_cd = 'MPCS'
   and r1.src_tab_en_name = 'MPCS_A20TSAFEBOXDETAIL'
   and r1.src_field_en_name = 'OPENPSNFLAG'
   and r1.target_tab_en_name = 'EVT_TSAFEBOX_SWI_DTL'
   and r1.target_tab_field_en_name = 'UNPACKER_PUB_PRIV_IDF_CD'
  left join ${iml_schema}.ref_pub_cd_map r2
    on p1.userflag = r2.src_code_val
   and r2.sorc_sys_cd = 'MPCS'
   and r2.src_tab_en_name = 'MPCS_A20TSAFEBOXDETAIL'
   and r2.src_field_en_name = 'USERFLAG'
   and r2.target_tab_en_name = 'EVT_TSAFEBOX_SWI_DTL'
   and r2.target_tab_field_en_name = 'ACTL_USER_PUB_PRIV_IDF_CD'
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_tsafebox_swi_dtl truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_tsafebox_swi_dtl exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_tsafebox_swi_dtl_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tsafebox_swi_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_tsafebox_swi_dtl_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tsafebox_swi_dtl', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);