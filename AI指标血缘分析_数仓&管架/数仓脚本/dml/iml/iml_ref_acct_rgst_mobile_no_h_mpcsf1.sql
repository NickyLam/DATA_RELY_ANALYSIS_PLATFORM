/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_acct_rgst_mobile_no_h_mpcsf1
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
alter table ${iml_schema}.ref_acct_rgst_mobile_no_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_acct_rgst_mobile_no_h partition for ('mpcsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_tm purge;
drop table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_op purge;
drop table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,acct_num_rgst_attr_cd -- 账号注册属性代码
    ,onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,acct_open_bank_no -- 账户开户行行号
    ,acct_clear_bank_no -- 账户清算行行号
    ,rgst_tm -- 登记时间
    ,mobile_no_status_cd -- 手机号状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_acct_rgst_mobile_no_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_acct_rgst_mobile_no_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_acct_rgst_mobile_no_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a10tibpsregedittelinfo-
insert into ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_tm(
    mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,acct_num_rgst_attr_cd -- 账号注册属性代码
    ,onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,acct_open_bank_no -- 账户开户行行号
    ,acct_clear_bank_no -- 账户清算行行号
    ,rgst_tm -- 登记时间
    ,mobile_no_status_cd -- 手机号状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TEL -- 手机号码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.IDTYPE END -- 证件类型代码
    ,P1.IDCODE -- 证件号码
    ,P1.ACCTNO -- 账号
    ,P1.ACCTNAME -- 账户名称
    ,nvl(trim(P1.DFTACCTTP),'-') -- 账号注册属性代码
    ,P1.REJECTBANK -- 网银系统开户行行号
    ,P1.ACCTOPENBRN -- 账户开户行行号
    ,P1.SDFICODE -- 账户清算行行号
    ,${iml_schema}.DATEFORMAT_MIN(P1.REGEDITTM) -- 登记时间
    ,replace(replace(P1.STATUS, 'CHR(10)', ''), CHR(13), '') -- 手机号状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a10tibpsregedittelinfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a10tibpsregedittelinfo p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.IDTYPE  = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A10TIBPSREGEDITTELINFO'
        AND R1.SRC_FIELD_EN_NAME= 'IDTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'REF_ACCT_RGST_MOBILE_NO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_cl(
            mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,acct_num_rgst_attr_cd -- 账号注册属性代码
    ,onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,acct_open_bank_no -- 账户开户行行号
    ,acct_clear_bank_no -- 账户清算行行号
    ,rgst_tm -- 登记时间
    ,mobile_no_status_cd -- 手机号状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_op(
            mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,acct_num_rgst_attr_cd -- 账号注册属性代码
    ,onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,acct_open_bank_no -- 账户开户行行号
    ,acct_clear_bank_no -- 账户清算行行号
    ,rgst_tm -- 登记时间
    ,mobile_no_status_cd -- 手机号状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.acct_num, o.acct_num) as acct_num -- 账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_num_rgst_attr_cd, o.acct_num_rgst_attr_cd) as acct_num_rgst_attr_cd -- 账号注册属性代码
    ,nvl(n.onl_bank_sys_open_bank_no, o.onl_bank_sys_open_bank_no) as onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,nvl(n.acct_open_bank_no, o.acct_open_bank_no) as acct_open_bank_no -- 账户开户行行号
    ,nvl(n.acct_clear_bank_no, o.acct_clear_bank_no) as acct_clear_bank_no -- 账户清算行行号
    ,nvl(n.rgst_tm, o.rgst_tm) as rgst_tm -- 登记时间
    ,nvl(n.mobile_no_status_cd, o.mobile_no_status_cd) as mobile_no_status_cd -- 手机号状态代码
    ,case when
            n.mobile_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mobile_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mobile_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.mobile_no = n.mobile_no
where (
        o.mobile_no is null
    )
    or (
        n.mobile_no is null
    )
    or (
        o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.acct_num <> n.acct_num
        or o.acct_name <> n.acct_name
        or o.acct_num_rgst_attr_cd <> n.acct_num_rgst_attr_cd
        or o.onl_bank_sys_open_bank_no <> n.onl_bank_sys_open_bank_no
        or o.acct_open_bank_no <> n.acct_open_bank_no
        or o.acct_clear_bank_no <> n.acct_clear_bank_no
        or o.rgst_tm <> n.rgst_tm
        or o.mobile_no_status_cd <> n.mobile_no_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_cl(
            mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,acct_num_rgst_attr_cd -- 账号注册属性代码
    ,onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,acct_open_bank_no -- 账户开户行行号
    ,acct_clear_bank_no -- 账户清算行行号
    ,rgst_tm -- 登记时间
    ,mobile_no_status_cd -- 手机号状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_op(
            mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,acct_num_rgst_attr_cd -- 账号注册属性代码
    ,onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,acct_open_bank_no -- 账户开户行行号
    ,acct_clear_bank_no -- 账户清算行行号
    ,rgst_tm -- 登记时间
    ,mobile_no_status_cd -- 手机号状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mobile_no -- 手机号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.acct_num -- 账号
    ,o.acct_name -- 账户名称
    ,o.acct_num_rgst_attr_cd -- 账号注册属性代码
    ,o.onl_bank_sys_open_bank_no -- 网银系统开户行行号
    ,o.acct_open_bank_no -- 账户开户行行号
    ,o.acct_clear_bank_no -- 账户清算行行号
    ,o.rgst_tm -- 登记时间
    ,o.mobile_no_status_cd -- 手机号状态代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_bk o
    left join ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_op n
        on
            o.mobile_no = n.mobile_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_cl d
        on
            o.mobile_no = d.mobile_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_acct_rgst_mobile_no_h;
alter table ${iml_schema}.ref_acct_rgst_mobile_no_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_acct_rgst_mobile_no_h exchange subpartition p_mpcsf1_19000101 with table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_cl;
alter table ${iml_schema}.ref_acct_rgst_mobile_no_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_acct_rgst_mobile_no_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_tm purge;
drop table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_op purge;
drop table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_acct_rgst_mobile_no_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_acct_rgst_mobile_no_h', partname => 'p_mpcsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
