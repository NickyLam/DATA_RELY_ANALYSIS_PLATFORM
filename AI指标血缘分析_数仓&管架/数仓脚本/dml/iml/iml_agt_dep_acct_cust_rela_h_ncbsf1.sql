/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_acct_cust_rela_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_acct_cust_rela_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_cust_rela_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,actl_acct_num -- 实际账号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,priv_flg -- 对私标志
    ,chn_id -- 渠道编号
    ,card_flg -- 卡标志
    ,open_acct_org_id -- 开户机构编号
    ,acct_kind_cd -- 账户种类代码
    ,acct_status_cd -- 账户状态代码
    ,acct_attr_cd -- 账户属性代码
    ,vtual_acct_flg -- 虚户标志
    ,deflt_stl_acct_num_flg -- 默认结算账号标志
    ,main_acct_flg -- 主账户标志
    ,super_acct_id -- 上级账户编号
    ,acct_usage_cd -- 账户用途代码
    ,supp_card_flg -- 附属卡标志
    ,corp_stl_card_flg -- 单位结算卡标志
    ,tran_dt -- 交易日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_cust_rela_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_cust_rela_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_acct_cust_rela_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_acct_client_relation-1
insert into ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,actl_acct_num -- 实际账号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,priv_flg -- 对私标志
    ,chn_id -- 渠道编号
    ,card_flg -- 卡标志
    ,open_acct_org_id -- 开户机构编号
    ,acct_kind_cd -- 账户种类代码
    ,acct_status_cd -- 账户状态代码
    ,acct_attr_cd -- 账户属性代码
    ,vtual_acct_flg -- 虚户标志
    ,deflt_stl_acct_num_flg -- 默认结算账号标志
    ,main_acct_flg -- 主账户标志
    ,super_acct_id -- 上级账户编号
    ,acct_usage_cd -- 账户用途代码
    ,supp_card_flg -- 附属卡标志
    ,corp_stl_card_flg -- 单位结算卡标志
    ,tran_dt -- 交易日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||to_char(P1.INTERNAL_KEY) -- 协议编号
    ,'9999' -- 法人编号
    ,to_char(P1.INTERNAL_KEY) -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.ACTUAL_ACCT_NO -- 实际账号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.ACCT_NAME -- 账户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.DOCUMENT_ID -- 证件号码
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 证件类型代码
    ,decode(P1.INDIVIDUAL_FLAG,'Y','1','N','0',' ','-',P1.INDIVIDUAL_FLAG) -- 对私标志
    ,nvl(trim(P1.SOURCE_TYPE),'0000') -- 渠道编号
    ,decode(P1.IS_CARD,'Y','1','N','0',' ','-',P1.IS_CARD) -- 卡标志
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,nvl(trim(P1.ACCT_CLASS),'-') -- 账户种类代码
    ,nvl(trim(P1.ACCT_STATUS),'-') -- 账户状态代码
    ,nvl(trim(P1.ACCT_NATURE),'-') -- 账户属性代码
    ,decode(P1.ACCT_REAL_FLAG,'Y','1','N','0',' ','-',P1.ACCT_REAL_FLAG) -- 虚户标志
    ,decode(P1.DEFAULT_SETTLE_ACCT,'Y','1','N','0',' ','-',P1.DEFAULT_SETTLE_ACCT) -- 默认结算账号标志
    ,decode(P1.LEAD_ACCT_FLAG,'Y','1','N','0',' ','-',P1.LEAD_ACCT_FLAG) -- 主账户标志
    ,to_char(P1.PARENT_INTERNAL_KEY) -- 上级账户编号
    ,nvl(trim(P1.REASON_CODE),'-') -- 账户用途代码
    ,decode(P1.APP_FLAG,'Y','1','N','0',' ','-',P1.APP_FLAG) -- 附属卡标志
    ,decode(P1.IS_CORP_SETTLE_CARD,'Y','1','N','0',' ','-',P1.IS_CORP_SETTLE_CARD) -- 单位结算卡标志
    ,${iml_schema}.timeformat_max2(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_acct_client_relation' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_acct_client_relation p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE=R1.SRC_CODE_VAL
           AND R1.SORC_SYS_CD= 'NCBS'
           AND R1.SRC_TAB_EN_NAME ='NCBS_RB_ACCT_CLIENT_RELATION'
           AND R1.SRC_FIELD_EN_NAME ='CLIENT_TYPE'
           AND R1.TARGET_TAB_EN_NAME='AGT_DEP_ACCT_CUST_RELA_H'
           AND R1.TARGET_TAB_FIELD_EN_NAME='CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
  	                                        ,cust_id
  	                                        ,actl_acct_num
  	                                        ,cust_acct_num
  	                                        ,prod_id
  	                                        ,curr_cd
  	                                        ,sub_acct_num
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
        into ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,actl_acct_num -- 实际账号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,priv_flg -- 对私标志
    ,chn_id -- 渠道编号
    ,card_flg -- 卡标志
    ,open_acct_org_id -- 开户机构编号
    ,acct_kind_cd -- 账户种类代码
    ,acct_status_cd -- 账户状态代码
    ,acct_attr_cd -- 账户属性代码
    ,vtual_acct_flg -- 虚户标志
    ,deflt_stl_acct_num_flg -- 默认结算账号标志
    ,main_acct_flg -- 主账户标志
    ,super_acct_id -- 上级账户编号
    ,acct_usage_cd -- 账户用途代码
    ,supp_card_flg -- 附属卡标志
    ,corp_stl_card_flg -- 单位结算卡标志
    ,tran_dt -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,actl_acct_num -- 实际账号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,priv_flg -- 对私标志
    ,chn_id -- 渠道编号
    ,card_flg -- 卡标志
    ,open_acct_org_id -- 开户机构编号
    ,acct_kind_cd -- 账户种类代码
    ,acct_status_cd -- 账户状态代码
    ,acct_attr_cd -- 账户属性代码
    ,vtual_acct_flg -- 虚户标志
    ,deflt_stl_acct_num_flg -- 默认结算账号标志
    ,main_acct_flg -- 主账户标志
    ,super_acct_id -- 上级账户编号
    ,acct_usage_cd -- 账户用途代码
    ,supp_card_flg -- 附属卡标志
    ,corp_stl_card_flg -- 单位结算卡标志
    ,tran_dt -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.actl_acct_num, o.actl_acct_num) as actl_acct_num -- 实际账号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.priv_flg, o.priv_flg) as priv_flg -- 对私标志
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.card_flg, o.card_flg) as card_flg -- 卡标志
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.acct_kind_cd, o.acct_kind_cd) as acct_kind_cd -- 账户种类代码
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.acct_attr_cd, o.acct_attr_cd) as acct_attr_cd -- 账户属性代码
    ,nvl(n.vtual_acct_flg, o.vtual_acct_flg) as vtual_acct_flg -- 虚户标志
    ,nvl(n.deflt_stl_acct_num_flg, o.deflt_stl_acct_num_flg) as deflt_stl_acct_num_flg -- 默认结算账号标志
    ,nvl(n.main_acct_flg, o.main_acct_flg) as main_acct_flg -- 主账户标志
    ,nvl(n.super_acct_id, o.super_acct_id) as super_acct_id -- 上级账户编号
    ,nvl(n.acct_usage_cd, o.acct_usage_cd) as acct_usage_cd -- 账户用途代码
    ,nvl(n.supp_card_flg, o.supp_card_flg) as supp_card_flg -- 附属卡标志
    ,nvl(n.corp_stl_card_flg, o.corp_stl_card_flg) as corp_stl_card_flg -- 单位结算卡标志
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.cust_id is null
            and n.actl_acct_num is null
            and n.cust_acct_num is null
            and n.prod_id is null
            and n.curr_cd is null
            and n.sub_acct_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.cust_id is null
            and n.actl_acct_num is null
            and n.cust_acct_num is null
            and n.prod_id is null
            and n.curr_cd is null
            and n.sub_acct_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
            and n.cust_id is null
            and n.actl_acct_num is null
            and n.cust_acct_num is null
            and n.prod_id is null
            and n.curr_cd is null
            and n.sub_acct_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.cust_id = n.cust_id
            and o.actl_acct_num = n.actl_acct_num
            and o.cust_acct_num = n.cust_acct_num
            and o.prod_id = n.prod_id
            and o.curr_cd = n.curr_cd
            and o.sub_acct_num = n.sub_acct_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
        and o.cust_id is null
        and o.actl_acct_num is null
        and o.cust_acct_num is null
        and o.prod_id is null
        and o.curr_cd is null
        and o.sub_acct_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
        and n.cust_id is null
        and n.actl_acct_num is null
        and n.cust_acct_num is null
        and n.prod_id is null
        and n.curr_cd is null
        and n.sub_acct_num is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.cust_type_cd <> n.cust_type_cd
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.priv_flg <> n.priv_flg
        or o.chn_id <> n.chn_id
        or o.card_flg <> n.card_flg
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.acct_kind_cd <> n.acct_kind_cd
        or o.acct_status_cd <> n.acct_status_cd
        or o.acct_attr_cd <> n.acct_attr_cd
        or o.vtual_acct_flg <> n.vtual_acct_flg
        or o.deflt_stl_acct_num_flg <> n.deflt_stl_acct_num_flg
        or o.main_acct_flg <> n.main_acct_flg
        or o.super_acct_id <> n.super_acct_id
        or o.acct_usage_cd <> n.acct_usage_cd
        or o.supp_card_flg <> n.supp_card_flg
        or o.corp_stl_card_flg <> n.corp_stl_card_flg
        or o.tran_dt <> n.tran_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,actl_acct_num -- 实际账号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,priv_flg -- 对私标志
    ,chn_id -- 渠道编号
    ,card_flg -- 卡标志
    ,open_acct_org_id -- 开户机构编号
    ,acct_kind_cd -- 账户种类代码
    ,acct_status_cd -- 账户状态代码
    ,acct_attr_cd -- 账户属性代码
    ,vtual_acct_flg -- 虚户标志
    ,deflt_stl_acct_num_flg -- 默认结算账号标志
    ,main_acct_flg -- 主账户标志
    ,super_acct_id -- 上级账户编号
    ,acct_usage_cd -- 账户用途代码
    ,supp_card_flg -- 附属卡标志
    ,corp_stl_card_flg -- 单位结算卡标志
    ,tran_dt -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,actl_acct_num -- 实际账号
    ,cust_acct_num -- 客户账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,priv_flg -- 对私标志
    ,chn_id -- 渠道编号
    ,card_flg -- 卡标志
    ,open_acct_org_id -- 开户机构编号
    ,acct_kind_cd -- 账户种类代码
    ,acct_status_cd -- 账户状态代码
    ,acct_attr_cd -- 账户属性代码
    ,vtual_acct_flg -- 虚户标志
    ,deflt_stl_acct_num_flg -- 默认结算账号标志
    ,main_acct_flg -- 主账户标志
    ,super_acct_id -- 上级账户编号
    ,acct_usage_cd -- 账户用途代码
    ,supp_card_flg -- 附属卡标志
    ,corp_stl_card_flg -- 单位结算卡标志
    ,tran_dt -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.acct_id -- 账户编号
    ,o.cust_id -- 客户编号
    ,o.actl_acct_num -- 实际账号
    ,o.cust_acct_num -- 客户账号
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.sub_acct_num -- 子账号
    ,o.acct_name -- 账户名称
    ,o.cust_type_cd -- 客户类型代码
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.priv_flg -- 对私标志
    ,o.chn_id -- 渠道编号
    ,o.card_flg -- 卡标志
    ,o.open_acct_org_id -- 开户机构编号
    ,o.acct_kind_cd -- 账户种类代码
    ,o.acct_status_cd -- 账户状态代码
    ,o.acct_attr_cd -- 账户属性代码
    ,o.vtual_acct_flg -- 虚户标志
    ,o.deflt_stl_acct_num_flg -- 默认结算账号标志
    ,o.main_acct_flg -- 主账户标志
    ,o.super_acct_id -- 上级账户编号
    ,o.acct_usage_cd -- 账户用途代码
    ,o.supp_card_flg -- 附属卡标志
    ,o.corp_stl_card_flg -- 单位结算卡标志
    ,o.tran_dt -- 交易日期
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
from ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.cust_id = n.cust_id
            and o.actl_acct_num = n.actl_acct_num
            and o.cust_acct_num = n.cust_acct_num
            and o.prod_id = n.prod_id
            and o.curr_cd = n.curr_cd
            and o.sub_acct_num = n.sub_acct_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
            and o.cust_id = d.cust_id
            and o.actl_acct_num = d.actl_acct_num
            and o.cust_acct_num = d.cust_acct_num
            and o.prod_id = d.prod_id
            and o.curr_cd = d.curr_cd
            and o.sub_acct_num = d.sub_acct_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_acct_cust_rela_h;
--alter table ${iml_schema}.agt_dep_acct_cust_rela_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_dep_acct_cust_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_dep_acct_cust_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_dep_acct_cust_rela_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_dep_acct_cust_rela_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_acct_cust_rela_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_acct_cust_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_acct_cust_rela_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_acct_cust_rela_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
