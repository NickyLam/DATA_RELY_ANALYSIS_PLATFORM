/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_moy_box_card_info_h_ncbsf1
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
drop table ${iml_schema}.ref_moy_box_card_info_h_ncbsf1_tm purge;
alter table ${iml_schema}.ref_moy_box_card_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_moy_box_card_info_h modify partition p_ncbsf1
    add subpartition p_ncbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_moy_box_card_info_h_ncbsf1_tm
compress ${option_switch} for query high
as
select
    card_no -- 卡号
    ,lp_id -- 法人编号
    ,card_vouch_status -- 卡凭证状态代码
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,nomi_card_flg -- 记名卡标志
    ,supp_card_flg -- 附属卡标志
    ,main_card_card_no -- 主卡卡号
    ,appl_id -- 申请编号
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,card_cnv -- 卡片CVN信息
    ,card_med_type_cd -- 卡介质类型代码
    ,card_psbook_merge_one_flg -- 卡折合一标志
    ,card_status_cd -- 卡状态代码
    ,change_card_cnt -- 换卡次数
    ,issue_dt -- 发行日期
    ,tran_tm -- 交易时间
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,appl_teller_id -- 申请柜员编号
    ,card_iss_teller_id -- 发卡柜员编号
    ,core_tran_org_id -- 核心交易机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_moy_box_card_info_h
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cd_card_prev-1
insert into ${iml_schema}.ref_moy_box_card_info_h_ncbsf1_tm(
    card_no -- 卡号
    ,lp_id -- 法人编号
    ,card_vouch_status -- 卡凭证状态代码
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,nomi_card_flg -- 记名卡标志
    ,supp_card_flg -- 附属卡标志
    ,main_card_card_no -- 主卡卡号
    ,appl_id -- 申请编号
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,card_cnv -- 卡片CVN信息
    ,card_med_type_cd -- 卡介质类型代码
    ,card_psbook_merge_one_flg -- 卡折合一标志
    ,card_status_cd -- 卡状态代码
    ,change_card_cnt -- 换卡次数
    ,issue_dt -- 发行日期
    ,tran_tm -- 交易时间
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,appl_teller_id -- 申请柜员编号
    ,card_iss_teller_id -- 发卡柜员编号
    ,core_tran_org_id -- 核心交易机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CARD_NO -- 卡号
    ,'9999' -- 法人编号
    ,nvl(trim(P1.CARD_VOUCHER_STATUS),'-') -- 卡凭证状态代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.SIGN_FLAG),'-') -- 记名卡标志
    ,decode(P1.APP_FLAG,'Y','1','N','0',' ','-',P1.APP_FLAG) -- 附属卡标志
    ,P1.MAIN_CARD_NO -- 主卡卡号
    ,P1.APPLY_NO -- 申请编号
    ,P1.BATCH_JOB_NO -- 制卡文件批次号
    ,P1.CARD_CVN -- 卡片CVN信息
    ,nvl(trim(P1.CARD_MEDIUM_TYPE),'-') -- 卡介质类型代码
    ,decode(P1.CARD_PB_UNION_FLAG,'Y','1','N','0',' ','-',P1.CARD_PB_UNION_FLAG) -- 卡折合一标志
    ,nvl(trim(P1.CARD_STATUS),'-') -- 卡状态代码
    ,to_number(nvl(trim(P1.CHANGE_CARD_NUM),'0')) -- 换卡次数
    ,P1.ISSUE_DATE -- 发行日期
    ,iml.timeformat_max(P1.TRAN_TIMESTAMP) -- 交易时间
    ,P1.VALID_FROM_DATE -- 生效日期
    ,P1.VALID_THRU_DATE -- 失效日期
    ,P1.APPLY_USER_ID -- 申请柜员编号
    ,P1.ISSUE_USER_ID -- 发卡柜员编号
    ,P1.TRAN_BRANCH -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cd_card_prev' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cd_card_prev p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.ref_moy_box_card_info_h truncate subpartition p_ncbsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.ref_moy_box_card_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.ref_moy_box_card_info_h_ncbsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_moy_box_card_info_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_moy_box_card_info_h_ncbsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_moy_box_card_info_h', partname => 'p_ncbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);