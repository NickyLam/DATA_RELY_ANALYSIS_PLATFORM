/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_vouch_change_dtl_info_ncbsi1
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
drop table ${iml_schema}.evt_vouch_change_dtl_info_ncbsi1_tm purge;
alter table ${iml_schema}.evt_vouch_change_dtl_info add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_vouch_change_dtl_info modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_vouch_change_dtl_info_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,vouch_change_id -- 凭证更换编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,new_card_num -- 新卡号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,init_vouch_type_cd -- 原凭证类型代码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,loss_id -- 挂失编号
    ,vouch_no -- 凭证号码
    ,vouch_modif_type_cd -- 凭证变更类型代码
    ,change_rs -- 更换原因
    ,ba_auth_teller_id -- 银承授权柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,lmt_id -- 限制编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_vouch_change_dtl_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_voucher_change_info-1
insert into ${iml_schema}.evt_vouch_change_dtl_info_ncbsi1_tm(
    evt_id -- 事件编号
    ,vouch_change_id -- 凭证更换编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,new_card_num -- 新卡号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,init_vouch_type_cd -- 原凭证类型代码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,loss_id -- 挂失编号
    ,vouch_no -- 凭证号码
    ,vouch_modif_type_cd -- 凭证变更类型代码
    ,change_rs -- 更换原因
    ,ba_auth_teller_id -- 银承授权柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,lmt_id -- 限制编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101037'||P1.MB_VOUCHER_CHANGE_NO -- 事件编号
    ,P1.MB_VOUCHER_CHANGE_NO -- 凭证更换编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.NEW_CARD_NO -- 新卡号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,nvl(trim(P1.DOC_TYPE),'-') -- 原凭证类型代码
    ,P1.NEW_DOC_TYPE -- 新凭证类型代码
    ,P1.NEW_VOUCHER_NO -- 新凭证号码
    ,P1.LOST_NO -- 挂失编号
    ,P1.VOUCHER_NO -- 凭证号码
    ,nvl(trim(P1.VOUCHER_CHANGE_TYPE),'-') -- 凭证变更类型代码
    ,P1.VOUCHER_CHANGE_REASON -- 更换原因
    ,P1.AUTH_USER_ID -- 银承授权柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,P1.RES_SEQ_NO -- 限制编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_voucher_change_info' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_voucher_change_info p1
    left join (select DISTINCT BASE_ACCT_NO,CARD_NO from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%'
where  1 = 1 
    and p1.tran_date = TO_DATE('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_vouch_change_dtl_info truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_vouch_change_dtl_info exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_vouch_change_dtl_info_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_vouch_change_dtl_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_vouch_change_dtl_info_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_vouch_change_dtl_info', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);