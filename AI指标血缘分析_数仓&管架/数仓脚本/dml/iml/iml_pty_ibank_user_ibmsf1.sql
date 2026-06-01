/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_ibank_user_ibmsf1
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
drop table ${iml_schema}.pty_ibank_user_ibmsf1_tm purge;
drop table ${iml_schema}.pty_ibank_user_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_ibank_user add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_ibank_user modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_ibank_user_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_ibank_user partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_ibank_user_ibmsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,user_id -- 用户编号
    ,user_name -- 用户姓名
    ,orgnz_id -- 组织机构编号
    ,mailbox -- 邮箱
    ,landine_no -- 座机号码
    ,mobile_no -- 手机号码
    ,badge_id -- 工牌编号
    ,name_pinyin -- 姓名拼音
    ,login_acct_num -- 登录账号
    ,birth_dt -- 出生日期
    ,user_type_cd -- 用户类型代码
    ,acct_num_status_cd -- 账号状态代码
    ,name_pinyin_head_letter -- 姓名拼音头字母
    ,fir_logon_flg -- 首次登陆标志
    ,rec_status_cd -- 记录状态代码
    ,qq_num -- qq号码
    ,encrypt_way_cd -- 加密方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_ibank_user
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_ibank_user_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_ibank_user partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_auth_user-
insert into ${iml_schema}.pty_ibank_user_ibmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,user_id -- 用户编号
    ,user_name -- 用户姓名
    ,orgnz_id -- 组织机构编号
    ,mailbox -- 邮箱
    ,landine_no -- 座机号码
    ,mobile_no -- 手机号码
    ,badge_id -- 工牌编号
    ,name_pinyin -- 姓名拼音
    ,login_acct_num -- 登录账号
    ,birth_dt -- 出生日期
    ,user_type_cd -- 用户类型代码
    ,acct_num_status_cd -- 账号状态代码
    ,name_pinyin_head_letter -- 姓名拼音头字母
    ,fir_logon_flg -- 首次登陆标志
    ,rec_status_cd -- 记录状态代码
    ,qq_num -- qq号码
    ,encrypt_way_cd -- 加密方式代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    TO_CHAR(P1.USER_ID) -- 当事人编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.USER_ID) -- 用户编号
    ,P1.USER_NAME -- 用户姓名
    ,TO_CHAR(P1.I_ID) -- 组织机构编号
    ,P1.EMAIL -- 邮箱
    ,P1.TEL_NUM -- 座机号码
    ,P1.MOBILE_NUM -- 手机号码
    ,P1.EMPLOYEE_CARD_NO -- 工牌编号
    ,P1.FULL_CHINESE_SPELL -- 姓名拼音
    ,P1.ACCOUNT -- 登录账号
    ,${iml_schema}.dateformat_max(P1.BIRTH_DAY) -- 出生日期
    ,NVL(TO_CHAR(P1.FLAG),'-') -- 用户类型代码
    ,NVL(TO_CHAR(P1.STATUS),'-') -- 账号状态代码
    ,P1.HEAD_CHINESE_SPELL -- 姓名拼音头字母
    ,P1.IS_FIRST_LOGIN -- 首次登陆标志
    ,P1.STATE -- 记录状态代码
    ,P1.QQ_NUMBER -- qq号码
    ,' ' -- 加密方式代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_auth_user' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_auth_user p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_ibank_user_ibmsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.pty_ibank_user_ibmsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,user_id -- 用户编号
    ,user_name -- 用户姓名
    ,orgnz_id -- 组织机构编号
    ,mailbox -- 邮箱
    ,landine_no -- 座机号码
    ,mobile_no -- 手机号码
    ,badge_id -- 工牌编号
    ,name_pinyin -- 姓名拼音
    ,login_acct_num -- 登录账号
    ,birth_dt -- 出生日期
    ,user_type_cd -- 用户类型代码
    ,acct_num_status_cd -- 账号状态代码
    ,name_pinyin_head_letter -- 姓名拼音头字母
    ,fir_logon_flg -- 首次登陆标志
    ,rec_status_cd -- 记录状态代码
    ,qq_num -- qq号码
    ,encrypt_way_cd -- 加密方式代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.user_id, o.user_id) as user_id -- 用户编号
    ,nvl(n.user_name, o.user_name) as user_name -- 用户姓名
    ,nvl(n.orgnz_id, o.orgnz_id) as orgnz_id -- 组织机构编号
    ,nvl(n.mailbox, o.mailbox) as mailbox -- 邮箱
    ,nvl(n.landine_no, o.landine_no) as landine_no -- 座机号码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.badge_id, o.badge_id) as badge_id -- 工牌编号
    ,nvl(n.name_pinyin, o.name_pinyin) as name_pinyin -- 姓名拼音
    ,nvl(n.login_acct_num, o.login_acct_num) as login_acct_num -- 登录账号
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.user_type_cd, o.user_type_cd) as user_type_cd -- 用户类型代码
    ,nvl(n.acct_num_status_cd, o.acct_num_status_cd) as acct_num_status_cd -- 账号状态代码
    ,nvl(n.name_pinyin_head_letter, o.name_pinyin_head_letter) as name_pinyin_head_letter -- 姓名拼音头字母
    ,nvl(n.fir_logon_flg, o.fir_logon_flg) as fir_logon_flg -- 首次登陆标志
    ,nvl(n.rec_status_cd, o.rec_status_cd) as rec_status_cd -- 记录状态代码
    ,nvl(n.qq_num, o.qq_num) as qq_num -- qq号码
    ,nvl(n.encrypt_way_cd, o.encrypt_way_cd) as encrypt_way_cd -- 加密方式代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.user_id <> n.user_id
                or o.user_name <> n.user_name
                or o.orgnz_id <> n.orgnz_id
                or o.mailbox <> n.mailbox
                or o.landine_no <> n.landine_no
                or o.mobile_no <> n.mobile_no
                or o.badge_id <> n.badge_id
                or o.name_pinyin <> n.name_pinyin
                or o.login_acct_num <> n.login_acct_num
                or o.birth_dt <> n.birth_dt
                or o.user_type_cd <> n.user_type_cd
                or o.acct_num_status_cd <> n.acct_num_status_cd
                or o.name_pinyin_head_letter <> n.name_pinyin_head_letter
                or o.fir_logon_flg <> n.fir_logon_flg
                or o.rec_status_cd <> n.rec_status_cd
                or o.qq_num <> n.qq_num
                or o.encrypt_way_cd <> n.encrypt_way_cd
            ) or (
                 case when (
                           n.party_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.party_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_ibank_user_ibmsf1_tm n
    full join ${iml_schema}.pty_ibank_user_ibmsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_ibank_user truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_ibank_user exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.pty_ibank_user_ibmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_ibank_user drop subpartition p_ibmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_ibank_user to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_ibank_user_ibmsf1_tm purge;
drop table ${iml_schema}.pty_ibank_user_ibmsf1_ex purge;
drop table ${iml_schema}.pty_ibank_user_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_ibank_user', partname => 'p_ibmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);