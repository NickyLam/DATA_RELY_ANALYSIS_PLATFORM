/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_card_basic_info_h_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_card_basic_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_card_basic_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_card_basic_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_card_basic_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_card_basic_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_card_basic_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_card_basic_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,cust_id -- 客户编号
    ,card_iss_dt -- 发卡日期
    ,card_iss_teller_id -- 发卡柜员编号
    ,bank_card_status_cd -- 银行卡状态代码
    ,change_card_cnt -- 换卡次数
    ,main_card_card_no -- 主卡卡号
    ,card_prod_id -- 卡产品编号
    ,sub_acct_num -- 子账号
    ,pin_card_rs -- 销卡原因
    ,pin_card_dt -- 销卡日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,pin_card_teller_id -- 销卡柜员编号
    ,card_iss_org_id -- 发卡机构编号
    ,card_med_type_cd -- 卡介质类型代码
    ,appl_id -- 申请编号
    ,supp_card_flg -- 附属卡标志
    ,stl_card_flg -- 单位结算卡标志
    ,card_psbook_merge_flg -- 卡折合一标志
    ,nomi_card_flg -- 记名卡标志
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,card_cvn_info -- 卡片CVN信息
    ,accu_fail_cnt -- 累积失败次数
    ,appl_teller_id -- 申请柜员编号
    ,last_modif_dt -- 上次修改日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_card_basic_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_card_basic_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_card_basic_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_card_basic_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_card_basic_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cd_card_arch-1
insert into ${iml_schema}.agt_card_basic_info_h_ncbsf1_tm(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,cust_id -- 客户编号
    ,card_iss_dt -- 发卡日期
    ,card_iss_teller_id -- 发卡柜员编号
    ,bank_card_status_cd -- 银行卡状态代码
    ,change_card_cnt -- 换卡次数
    ,main_card_card_no -- 主卡卡号
    ,card_prod_id -- 卡产品编号
    ,sub_acct_num -- 子账号
    ,pin_card_rs -- 销卡原因
    ,pin_card_dt -- 销卡日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,pin_card_teller_id -- 销卡柜员编号
    ,card_iss_org_id -- 发卡机构编号
    ,card_med_type_cd -- 卡介质类型代码
    ,appl_id -- 申请编号
    ,supp_card_flg -- 附属卡标志
    ,stl_card_flg -- 单位结算卡标志
    ,card_psbook_merge_flg -- 卡折合一标志
    ,nomi_card_flg -- 记名卡标志
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,card_cvn_info -- 卡片CVN信息
    ,accu_fail_cnt -- 累积失败次数
    ,appl_teller_id -- 申请柜员编号
    ,last_modif_dt -- 上次修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CARD_NO -- 凭证编号
    ,'9999' -- 法人编号
    ,P1.CARD_NO -- 卡号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.ISSUE_DATE -- 发卡日期
    ,P1.ISSUE_USER_ID -- 发卡柜员编号
    ,P1.CARD_STATUS -- 银行卡状态代码
    ,P1.CHANGE_CARD_NUM -- 换卡次数
    ,P1.MAIN_CARD_NO -- 主卡卡号
    ,P1.PROD_TYPE -- 卡产品编号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.CARD_CLOSE_REASON -- 销卡原因
    ,P1.CARD_CLOSE_DATE -- 销卡日期
    ,P1.VALID_FROM_DATE -- 生效日期
    ,P1.VALID_THRU_DATE -- 失效日期
    ,P1.CLOSE_USER_ID -- 销卡柜员编号
    ,P1.TRAN_BRANCH -- 发卡机构编号
    ,P1.CARD_MEDIUM_TYPE -- 卡介质类型代码
    ,P1.APPLY_NO -- 申请编号
    ,decode(trim(p1.APP_FLAG),'','-','Y','1','N','0',p1.APP_FLAG) -- 附属卡标志
    ,decode(trim(p1.IS_CORP_SETTLE_CARD),'','-','Y','1','N','0',p1.IS_CORP_SETTLE_CARD) -- 单位结算卡标志
    ,decode(trim(p1.CARD_PB_UNION_FLAG),'','-','Y','1','N','0',p1.CARD_PB_UNION_FLAG) -- 卡折合一标志
    ,decode(trim(p1.SIGN_FLAG),'','-','Y','1','N','0',p1.SIGN_FLAG) -- 记名卡标志
    ,P1.BATCH_JOB_NO -- 制卡文件批次号
    ,P1.CARD_CVN -- 卡片CVN信息
    ,P1.FAILURE_TIMES -- 累积失败次数
    ,P1.APPLY_USER_ID -- 申请柜员编号
    ,iml.dateformat_max2(P1.LAST_CHANGE_TIME) -- 上次修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cd_card_arch' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cd_card_arch p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_card_basic_info_h_ncbsf1_tm 
  	                                group by 
  	                                        vouch_id
  	                                        ,lp_id
  	                                        ,card_no
  	                                        ,bank_card_status_cd
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_card_basic_info_h_ncbsf1_cl(
            vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,cust_id -- 客户编号
    ,card_iss_dt -- 发卡日期
    ,card_iss_teller_id -- 发卡柜员编号
    ,bank_card_status_cd -- 银行卡状态代码
    ,change_card_cnt -- 换卡次数
    ,main_card_card_no -- 主卡卡号
    ,card_prod_id -- 卡产品编号
    ,sub_acct_num -- 子账号
    ,pin_card_rs -- 销卡原因
    ,pin_card_dt -- 销卡日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,pin_card_teller_id -- 销卡柜员编号
    ,card_iss_org_id -- 发卡机构编号
    ,card_med_type_cd -- 卡介质类型代码
    ,appl_id -- 申请编号
    ,supp_card_flg -- 附属卡标志
    ,stl_card_flg -- 单位结算卡标志
    ,card_psbook_merge_flg -- 卡折合一标志
    ,nomi_card_flg -- 记名卡标志
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,card_cvn_info -- 卡片CVN信息
    ,accu_fail_cnt -- 累积失败次数
    ,appl_teller_id -- 申请柜员编号
    ,last_modif_dt -- 上次修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_card_basic_info_h_ncbsf1_op(
            vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,cust_id -- 客户编号
    ,card_iss_dt -- 发卡日期
    ,card_iss_teller_id -- 发卡柜员编号
    ,bank_card_status_cd -- 银行卡状态代码
    ,change_card_cnt -- 换卡次数
    ,main_card_card_no -- 主卡卡号
    ,card_prod_id -- 卡产品编号
    ,sub_acct_num -- 子账号
    ,pin_card_rs -- 销卡原因
    ,pin_card_dt -- 销卡日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,pin_card_teller_id -- 销卡柜员编号
    ,card_iss_org_id -- 发卡机构编号
    ,card_med_type_cd -- 卡介质类型代码
    ,appl_id -- 申请编号
    ,supp_card_flg -- 附属卡标志
    ,stl_card_flg -- 单位结算卡标志
    ,card_psbook_merge_flg -- 卡折合一标志
    ,nomi_card_flg -- 记名卡标志
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,card_cvn_info -- 卡片CVN信息
    ,accu_fail_cnt -- 累积失败次数
    ,appl_teller_id -- 申请柜员编号
    ,last_modif_dt -- 上次修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.card_iss_dt, o.card_iss_dt) as card_iss_dt -- 发卡日期
    ,nvl(n.card_iss_teller_id, o.card_iss_teller_id) as card_iss_teller_id -- 发卡柜员编号
    ,nvl(n.bank_card_status_cd, o.bank_card_status_cd) as bank_card_status_cd -- 银行卡状态代码
    ,nvl(n.change_card_cnt, o.change_card_cnt) as change_card_cnt -- 换卡次数
    ,nvl(n.main_card_card_no, o.main_card_card_no) as main_card_card_no -- 主卡卡号
    ,nvl(n.card_prod_id, o.card_prod_id) as card_prod_id -- 卡产品编号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.pin_card_rs, o.pin_card_rs) as pin_card_rs -- 销卡原因
    ,nvl(n.pin_card_dt, o.pin_card_dt) as pin_card_dt -- 销卡日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.pin_card_teller_id, o.pin_card_teller_id) as pin_card_teller_id -- 销卡柜员编号
    ,nvl(n.card_iss_org_id, o.card_iss_org_id) as card_iss_org_id -- 发卡机构编号
    ,nvl(n.card_med_type_cd, o.card_med_type_cd) as card_med_type_cd -- 卡介质类型代码
    ,nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.supp_card_flg, o.supp_card_flg) as supp_card_flg -- 附属卡标志
    ,nvl(n.stl_card_flg, o.stl_card_flg) as stl_card_flg -- 单位结算卡标志
    ,nvl(n.card_psbook_merge_flg, o.card_psbook_merge_flg) as card_psbook_merge_flg -- 卡折合一标志
    ,nvl(n.nomi_card_flg, o.nomi_card_flg) as nomi_card_flg -- 记名卡标志
    ,nvl(n.make_card_doc_batch_no, o.make_card_doc_batch_no) as make_card_doc_batch_no -- 制卡文件批次号
    ,nvl(n.card_cvn_info, o.card_cvn_info) as card_cvn_info -- 卡片CVN信息
    ,nvl(n.accu_fail_cnt, o.accu_fail_cnt) as accu_fail_cnt -- 累积失败次数
    ,nvl(n.appl_teller_id, o.appl_teller_id) as appl_teller_id -- 申请柜员编号
    ,nvl(n.last_modif_dt, o.last_modif_dt) as last_modif_dt -- 上次修改日期
    ,case when
            n.vouch_id is null
            and n.lp_id is null
            and n.card_no is null
            and n.bank_card_status_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.vouch_id is null
            and n.lp_id is null
            and n.card_no is null
            and n.bank_card_status_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.vouch_id is null
            and n.lp_id is null
            and n.card_no is null
            and n.bank_card_status_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_card_basic_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_card_basic_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
            and o.card_no = n.card_no
            and o.bank_card_status_cd = n.bank_card_status_cd
where (
        o.vouch_id is null
        and o.lp_id is null
        and o.card_no is null
        and o.bank_card_status_cd is null
    )
    or (
        n.vouch_id is null
        and n.lp_id is null
        and n.card_no is null
        and n.bank_card_status_cd is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.card_iss_dt <> n.card_iss_dt
        or o.card_iss_teller_id <> n.card_iss_teller_id
        or o.change_card_cnt <> n.change_card_cnt
        or o.main_card_card_no <> n.main_card_card_no
        or o.card_prod_id <> n.card_prod_id
        or o.sub_acct_num <> n.sub_acct_num
        or o.pin_card_rs <> n.pin_card_rs
        or o.pin_card_dt <> n.pin_card_dt
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.pin_card_teller_id <> n.pin_card_teller_id
        or o.card_iss_org_id <> n.card_iss_org_id
        or o.card_med_type_cd <> n.card_med_type_cd
        or o.appl_id <> n.appl_id
        or o.supp_card_flg <> n.supp_card_flg
        or o.stl_card_flg <> n.stl_card_flg
        or o.card_psbook_merge_flg <> n.card_psbook_merge_flg
        or o.nomi_card_flg <> n.nomi_card_flg
        or o.make_card_doc_batch_no <> n.make_card_doc_batch_no
        or o.card_cvn_info <> n.card_cvn_info
        or o.accu_fail_cnt <> n.accu_fail_cnt
        or o.appl_teller_id <> n.appl_teller_id
        or o.last_modif_dt <> n.last_modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_card_basic_info_h_ncbsf1_cl(
            vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,cust_id -- 客户编号
    ,card_iss_dt -- 发卡日期
    ,card_iss_teller_id -- 发卡柜员编号
    ,bank_card_status_cd -- 银行卡状态代码
    ,change_card_cnt -- 换卡次数
    ,main_card_card_no -- 主卡卡号
    ,card_prod_id -- 卡产品编号
    ,sub_acct_num -- 子账号
    ,pin_card_rs -- 销卡原因
    ,pin_card_dt -- 销卡日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,pin_card_teller_id -- 销卡柜员编号
    ,card_iss_org_id -- 发卡机构编号
    ,card_med_type_cd -- 卡介质类型代码
    ,appl_id -- 申请编号
    ,supp_card_flg -- 附属卡标志
    ,stl_card_flg -- 单位结算卡标志
    ,card_psbook_merge_flg -- 卡折合一标志
    ,nomi_card_flg -- 记名卡标志
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,card_cvn_info -- 卡片CVN信息
    ,accu_fail_cnt -- 累积失败次数
    ,appl_teller_id -- 申请柜员编号
    ,last_modif_dt -- 上次修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_card_basic_info_h_ncbsf1_op(
            vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,cust_id -- 客户编号
    ,card_iss_dt -- 发卡日期
    ,card_iss_teller_id -- 发卡柜员编号
    ,bank_card_status_cd -- 银行卡状态代码
    ,change_card_cnt -- 换卡次数
    ,main_card_card_no -- 主卡卡号
    ,card_prod_id -- 卡产品编号
    ,sub_acct_num -- 子账号
    ,pin_card_rs -- 销卡原因
    ,pin_card_dt -- 销卡日期
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,pin_card_teller_id -- 销卡柜员编号
    ,card_iss_org_id -- 发卡机构编号
    ,card_med_type_cd -- 卡介质类型代码
    ,appl_id -- 申请编号
    ,supp_card_flg -- 附属卡标志
    ,stl_card_flg -- 单位结算卡标志
    ,card_psbook_merge_flg -- 卡折合一标志
    ,nomi_card_flg -- 记名卡标志
    ,make_card_doc_batch_no -- 制卡文件批次号
    ,card_cvn_info -- 卡片CVN信息
    ,accu_fail_cnt -- 累积失败次数
    ,appl_teller_id -- 申请柜员编号
    ,last_modif_dt -- 上次修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.vouch_id -- 凭证编号
    ,o.lp_id -- 法人编号
    ,o.card_no -- 卡号
    ,o.cust_id -- 客户编号
    ,o.card_iss_dt -- 发卡日期
    ,o.card_iss_teller_id -- 发卡柜员编号
    ,o.bank_card_status_cd -- 银行卡状态代码
    ,o.change_card_cnt -- 换卡次数
    ,o.main_card_card_no -- 主卡卡号
    ,o.card_prod_id -- 卡产品编号
    ,o.sub_acct_num -- 子账号
    ,o.pin_card_rs -- 销卡原因
    ,o.pin_card_dt -- 销卡日期
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.pin_card_teller_id -- 销卡柜员编号
    ,o.card_iss_org_id -- 发卡机构编号
    ,o.card_med_type_cd -- 卡介质类型代码
    ,o.appl_id -- 申请编号
    ,o.supp_card_flg -- 附属卡标志
    ,o.stl_card_flg -- 单位结算卡标志
    ,o.card_psbook_merge_flg -- 卡折合一标志
    ,o.nomi_card_flg -- 记名卡标志
    ,o.make_card_doc_batch_no -- 制卡文件批次号
    ,o.card_cvn_info -- 卡片CVN信息
    ,o.accu_fail_cnt -- 累积失败次数
    ,o.appl_teller_id -- 申请柜员编号
    ,o.last_modif_dt -- 上次修改日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_card_basic_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_card_basic_info_h_ncbsf1_op n
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
            and o.card_no = n.card_no
            and o.bank_card_status_cd = n.bank_card_status_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_card_basic_info_h_ncbsf1_cl d
        on
            o.vouch_id = d.vouch_id
            and o.lp_id = d.lp_id
            and o.card_no = d.card_no
            and o.bank_card_status_cd = d.bank_card_status_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_card_basic_info_h;
--alter table ${iml_schema}.agt_card_basic_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_card_basic_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_card_basic_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_card_basic_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_card_basic_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_card_basic_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_card_basic_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_card_basic_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_card_basic_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_card_basic_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_card_basic_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_card_basic_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_card_basic_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_card_basic_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
