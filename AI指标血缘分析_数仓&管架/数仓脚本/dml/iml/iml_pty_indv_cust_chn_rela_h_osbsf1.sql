/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_indv_cust_chn_rela_h_osbsf1
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
alter table ${iml_schema}.pty_indv_cust_chn_rela_h add partition p_osbsf1 values ('osbsf1')(
        subpartition p_osbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_osbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_cust_chn_rela_h partition for ('osbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_tm purge;
drop table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_op purge;
drop table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,belong_plat_cd -- 所属平台代码
    ,lp_id -- 法人编号
    ,sign_chn_cd -- 签约渠道代码
    ,user_seq_num -- 用户顺序号
    ,logon_acct_id -- 登陆账户编号
    ,user_acct_status_cd -- 用户账户状态代码
    ,open_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,onl_bank_pause_status_cd -- 网银暂停状态代码
    ,onl_bank_pause_end_tm -- 网银暂停结束时间
    ,onl_bank_pause_start_tm -- 网银暂停开始时间
    ,mbank_pause_status_cd -- 手机银行暂停状态代码
    ,mbank_pause_start_tm -- 手机银行暂停开始时间
    ,mbank_pause_end_tm -- 手机银行暂停结束时间
    ,e_acct_sign_plat_cd -- 电子账户签约平台代码
    ,save_cert_way_cd -- 安全认证方式代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_cust_chn_rela_h partition for ('osbsf1')
where 0=1
;

create table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_cust_chn_rela_h partition for ('osbsf1') where 0=1;

create table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv_cust_chn_rela_h partition for ('osbsf1') where 0=1;

-- 3.1 get new data into table
-- osbs_pbs_ebankcif-1
insert into ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_tm(
    party_id -- 当事人编号
    ,belong_plat_cd -- 所属平台代码
    ,lp_id -- 法人编号
    ,sign_chn_cd -- 签约渠道代码
    ,user_seq_num -- 用户顺序号
    ,logon_acct_id -- 登陆账户编号
    ,user_acct_status_cd -- 用户账户状态代码
    ,open_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,onl_bank_pause_status_cd -- 网银暂停状态代码
    ,onl_bank_pause_end_tm -- 网银暂停结束时间
    ,onl_bank_pause_start_tm -- 网银暂停开始时间
    ,mbank_pause_status_cd -- 手机银行暂停状态代码
    ,mbank_pause_start_tm -- 手机银行暂停开始时间
    ,mbank_pause_end_tm -- 手机银行暂停结束时间
    ,e_acct_sign_plat_cd -- 电子账户签约平台代码
    ,save_cert_way_cd -- 安全认证方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PEC_ECIFNO -- 当事人编号
    ,P1.PEC_CHANNEL -- 所属平台代码
    ,'9999' -- 法人编号
    ,P1.PEC_SIGNCHANNEL  -- 签约渠道代码
    ,P1.PEC_USERNO -- 用户顺序号
    ,P1.PEC_LOGINID -- 登陆账户编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PEC_STATE END -- 用户账户状态代码
    ,${iml_schema}.timeformat_min(P1.PEC_OPENDATE) -- 开户时间
    ,${iml_schema}.timeformat_max(P1.PEC_CLOSEDATE) -- 销户时间
    ,P1.PEC_PBPAUSESTATE -- 网银暂停状态代码
    ,${iml_schema}.timeformat_max(P1.PEC_PBPAUSEDATE) -- 网银暂停结束时间
    ,${iml_schema}.timeformat_min(P1.PEC_PBPAUSEENDDATE) -- 网银暂停开始时间
    ,P1.PEC_MBPAUSESTATE -- 手机银行暂停状态代码
    ,${iml_schema}.timeformat_min(P1.PEC_MBPAUSEDATE) -- 手机银行暂停开始时间
    ,${iml_schema}.timeformat_max(P1.PEC_MOBILEPAUSEENDDATE) -- 手机银行暂停结束时间
    ,P1.PEC_EACCSIGNCHANNEL -- 电子账户签约平台代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.PEC_SECURITYTYPE END -- 安全认证方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'osbs_pbs_ebankcif' -- 源表名称
    ,'osbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.osbs_pbs_ebankcif p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PEC_STATE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'OSBS'
        AND R2.SRC_TAB_EN_NAME= 'OSBS_PBS_EBANKCIF'
        AND R2.SRC_FIELD_EN_NAME= 'PEC_STATE'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_INDV_CUST_CHN_RELA_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'USER_ACCT_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.PEC_SECURITYTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'OSBS'
        AND R3.SRC_TAB_EN_NAME= 'OSBS_PBS_EBANKCIF'
        AND R3.SRC_FIELD_EN_NAME= 'PEC_SECURITYTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'PTY_INDV_CUST_CHN_RELA_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'SAVE_CERT_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_cl(
            party_id -- 当事人编号
    ,belong_plat_cd -- 所属平台代码
    ,lp_id -- 法人编号
    ,sign_chn_cd -- 签约渠道代码
    ,user_seq_num -- 用户顺序号
    ,logon_acct_id -- 登陆账户编号
    ,user_acct_status_cd -- 用户账户状态代码
    ,open_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,onl_bank_pause_status_cd -- 网银暂停状态代码
    ,onl_bank_pause_end_tm -- 网银暂停结束时间
    ,onl_bank_pause_start_tm -- 网银暂停开始时间
    ,mbank_pause_status_cd -- 手机银行暂停状态代码
    ,mbank_pause_start_tm -- 手机银行暂停开始时间
    ,mbank_pause_end_tm -- 手机银行暂停结束时间
    ,e_acct_sign_plat_cd -- 电子账户签约平台代码
    ,save_cert_way_cd -- 安全认证方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_op(
            party_id -- 当事人编号
    ,belong_plat_cd -- 所属平台代码
    ,lp_id -- 法人编号
    ,sign_chn_cd -- 签约渠道代码
    ,user_seq_num -- 用户顺序号
    ,logon_acct_id -- 登陆账户编号
    ,user_acct_status_cd -- 用户账户状态代码
    ,open_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,onl_bank_pause_status_cd -- 网银暂停状态代码
    ,onl_bank_pause_end_tm -- 网银暂停结束时间
    ,onl_bank_pause_start_tm -- 网银暂停开始时间
    ,mbank_pause_status_cd -- 手机银行暂停状态代码
    ,mbank_pause_start_tm -- 手机银行暂停开始时间
    ,mbank_pause_end_tm -- 手机银行暂停结束时间
    ,e_acct_sign_plat_cd -- 电子账户签约平台代码
    ,save_cert_way_cd -- 安全认证方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.belong_plat_cd, o.belong_plat_cd) as belong_plat_cd -- 所属平台代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sign_chn_cd, o.sign_chn_cd) as sign_chn_cd -- 签约渠道代码
    ,nvl(n.user_seq_num, o.user_seq_num) as user_seq_num -- 用户顺序号
    ,nvl(n.logon_acct_id, o.logon_acct_id) as logon_acct_id -- 登陆账户编号
    ,nvl(n.user_acct_status_cd, o.user_acct_status_cd) as user_acct_status_cd -- 用户账户状态代码
    ,nvl(n.open_tm, o.open_tm) as open_tm -- 开户时间
    ,nvl(n.clos_acct_tm, o.clos_acct_tm) as clos_acct_tm -- 销户时间
    ,nvl(n.onl_bank_pause_status_cd, o.onl_bank_pause_status_cd) as onl_bank_pause_status_cd -- 网银暂停状态代码
    ,nvl(n.onl_bank_pause_end_tm, o.onl_bank_pause_end_tm) as onl_bank_pause_end_tm -- 网银暂停结束时间
    ,nvl(n.onl_bank_pause_start_tm, o.onl_bank_pause_start_tm) as onl_bank_pause_start_tm -- 网银暂停开始时间
    ,nvl(n.mbank_pause_status_cd, o.mbank_pause_status_cd) as mbank_pause_status_cd -- 手机银行暂停状态代码
    ,nvl(n.mbank_pause_start_tm, o.mbank_pause_start_tm) as mbank_pause_start_tm -- 手机银行暂停开始时间
    ,nvl(n.mbank_pause_end_tm, o.mbank_pause_end_tm) as mbank_pause_end_tm -- 手机银行暂停结束时间
    ,nvl(n.e_acct_sign_plat_cd, o.e_acct_sign_plat_cd) as e_acct_sign_plat_cd -- 电子账户签约平台代码
    ,nvl(n.save_cert_way_cd, o.save_cert_way_cd) as save_cert_way_cd -- 安全认证方式代码
    ,case when
            n.party_id is null
            and n.belong_plat_cd is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.belong_plat_cd is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.belong_plat_cd is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_tm n
    full join (select * from ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.belong_plat_cd = n.belong_plat_cd
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.belong_plat_cd is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.belong_plat_cd is null
        and n.lp_id is null
    )
    or (
        o.sign_chn_cd <> n.sign_chn_cd
        or o.user_seq_num <> n.user_seq_num
        or o.logon_acct_id <> n.logon_acct_id
        or o.user_acct_status_cd <> n.user_acct_status_cd
        or o.open_tm <> n.open_tm
        or o.clos_acct_tm <> n.clos_acct_tm
        or o.onl_bank_pause_status_cd <> n.onl_bank_pause_status_cd
        or o.onl_bank_pause_end_tm <> n.onl_bank_pause_end_tm
        or o.onl_bank_pause_start_tm <> n.onl_bank_pause_start_tm
        or o.mbank_pause_status_cd <> n.mbank_pause_status_cd
        or o.mbank_pause_start_tm <> n.mbank_pause_start_tm
        or o.mbank_pause_end_tm <> n.mbank_pause_end_tm
        or o.e_acct_sign_plat_cd <> n.e_acct_sign_plat_cd
        or o.save_cert_way_cd <> n.save_cert_way_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_cl(
            party_id -- 当事人编号
    ,belong_plat_cd -- 所属平台代码
    ,lp_id -- 法人编号
    ,sign_chn_cd -- 签约渠道代码
    ,user_seq_num -- 用户顺序号
    ,logon_acct_id -- 登陆账户编号
    ,user_acct_status_cd -- 用户账户状态代码
    ,open_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,onl_bank_pause_status_cd -- 网银暂停状态代码
    ,onl_bank_pause_end_tm -- 网银暂停结束时间
    ,onl_bank_pause_start_tm -- 网银暂停开始时间
    ,mbank_pause_status_cd -- 手机银行暂停状态代码
    ,mbank_pause_start_tm -- 手机银行暂停开始时间
    ,mbank_pause_end_tm -- 手机银行暂停结束时间
    ,e_acct_sign_plat_cd -- 电子账户签约平台代码
    ,save_cert_way_cd -- 安全认证方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_op(
            party_id -- 当事人编号
    ,belong_plat_cd -- 所属平台代码
    ,lp_id -- 法人编号
    ,sign_chn_cd -- 签约渠道代码
    ,user_seq_num -- 用户顺序号
    ,logon_acct_id -- 登陆账户编号
    ,user_acct_status_cd -- 用户账户状态代码
    ,open_tm -- 开户时间
    ,clos_acct_tm -- 销户时间
    ,onl_bank_pause_status_cd -- 网银暂停状态代码
    ,onl_bank_pause_end_tm -- 网银暂停结束时间
    ,onl_bank_pause_start_tm -- 网银暂停开始时间
    ,mbank_pause_status_cd -- 手机银行暂停状态代码
    ,mbank_pause_start_tm -- 手机银行暂停开始时间
    ,mbank_pause_end_tm -- 手机银行暂停结束时间
    ,e_acct_sign_plat_cd -- 电子账户签约平台代码
    ,save_cert_way_cd -- 安全认证方式代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.belong_plat_cd -- 所属平台代码
    ,o.lp_id -- 法人编号
    ,o.sign_chn_cd -- 签约渠道代码
    ,o.user_seq_num -- 用户顺序号
    ,o.logon_acct_id -- 登陆账户编号
    ,o.user_acct_status_cd -- 用户账户状态代码
    ,o.open_tm -- 开户时间
    ,o.clos_acct_tm -- 销户时间
    ,o.onl_bank_pause_status_cd -- 网银暂停状态代码
    ,o.onl_bank_pause_end_tm -- 网银暂停结束时间
    ,o.onl_bank_pause_start_tm -- 网银暂停开始时间
    ,o.mbank_pause_status_cd -- 手机银行暂停状态代码
    ,o.mbank_pause_start_tm -- 手机银行暂停开始时间
    ,o.mbank_pause_end_tm -- 手机银行暂停结束时间
    ,o.e_acct_sign_plat_cd -- 电子账户签约平台代码
    ,o.save_cert_way_cd -- 安全认证方式代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_bk o
    left join ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_op n
        on
            o.party_id = n.party_id
            and o.belong_plat_cd = n.belong_plat_cd
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_cl d
        on
            o.party_id = d.party_id
            and o.belong_plat_cd = d.belong_plat_cd
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_indv_cust_chn_rela_h;
alter table ${iml_schema}.pty_indv_cust_chn_rela_h truncate partition for ('osbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_indv_cust_chn_rela_h exchange subpartition p_osbsf1_19000101 with table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_cl;
alter table ${iml_schema}.pty_indv_cust_chn_rela_h exchange subpartition p_osbsf1_20991231 with table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_indv_cust_chn_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_tm purge;
drop table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_op purge;
drop table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_indv_cust_chn_rela_h_osbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_indv_cust_chn_rela_h', partname => 'p_osbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
