/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_ibank_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_ibank_user
whenever sqlerror continue none;
drop table ${iml_schema}.pty_ibank_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_ibank_user(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,user_id varchar2(60) -- 用户编号
    ,user_name varchar2(150) -- 用户姓名
    ,orgnz_id varchar2(60) -- 组织机构编号
    ,mailbox varchar2(375) -- 邮箱
    ,landine_no varchar2(60) -- 座机号码
    ,mobile_no varchar2(60) -- 手机号码
    ,badge_id varchar2(100) -- 工牌编号
    ,name_pinyin varchar2(375) -- 姓名拼音
    ,login_acct_num varchar2(60) -- 登录账号
    ,birth_dt date -- 出生日期
    ,user_type_cd varchar2(10) -- 用户类型代码
    ,acct_num_status_cd varchar2(10) -- 账号状态代码
    ,name_pinyin_head_letter varchar2(150) -- 姓名拼音头字母
    ,fir_logon_flg varchar2(10) -- 首次登陆标志
    ,rec_status_cd varchar2(10) -- 记录状态代码
    ,qq_num varchar2(60) -- qq号码
    ,encrypt_way_cd varchar2(30) -- 加密方式代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_ibank_user to ${icl_schema};
grant select on ${iml_schema}.pty_ibank_user to ${idl_schema};
grant select on ${iml_schema}.pty_ibank_user to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_ibank_user is '同业用户';
comment on column ${iml_schema}.pty_ibank_user.party_id is '当事人编号';
comment on column ${iml_schema}.pty_ibank_user.lp_id is '法人编号';
comment on column ${iml_schema}.pty_ibank_user.user_id is '用户编号';
comment on column ${iml_schema}.pty_ibank_user.user_name is '用户姓名';
comment on column ${iml_schema}.pty_ibank_user.orgnz_id is '组织机构编号';
comment on column ${iml_schema}.pty_ibank_user.mailbox is '邮箱';
comment on column ${iml_schema}.pty_ibank_user.landine_no is '座机号码';
comment on column ${iml_schema}.pty_ibank_user.mobile_no is '手机号码';
comment on column ${iml_schema}.pty_ibank_user.badge_id is '工牌编号';
comment on column ${iml_schema}.pty_ibank_user.name_pinyin is '姓名拼音';
comment on column ${iml_schema}.pty_ibank_user.login_acct_num is '登录账号';
comment on column ${iml_schema}.pty_ibank_user.birth_dt is '出生日期';
comment on column ${iml_schema}.pty_ibank_user.user_type_cd is '用户类型代码';
comment on column ${iml_schema}.pty_ibank_user.acct_num_status_cd is '账号状态代码';
comment on column ${iml_schema}.pty_ibank_user.name_pinyin_head_letter is '姓名拼音头字母';
comment on column ${iml_schema}.pty_ibank_user.fir_logon_flg is '首次登陆标志';
comment on column ${iml_schema}.pty_ibank_user.rec_status_cd is '记录状态代码';
comment on column ${iml_schema}.pty_ibank_user.qq_num is 'qq号码';
comment on column ${iml_schema}.pty_ibank_user.encrypt_way_cd is '加密方式代码';
comment on column ${iml_schema}.pty_ibank_user.create_dt is '创建日期';
comment on column ${iml_schema}.pty_ibank_user.update_dt is '更新日期';
comment on column ${iml_schema}.pty_ibank_user.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_ibank_user.id_mark is '增删标志';
comment on column ${iml_schema}.pty_ibank_user.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_ibank_user.job_cd is '任务编码';
comment on column ${iml_schema}.pty_ibank_user.etl_timestamp is 'ETL处理时间戳';
