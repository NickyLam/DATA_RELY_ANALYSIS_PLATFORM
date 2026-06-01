/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_pbs_ebankcif
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_pbs_ebankcif
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_pbs_ebankcif purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_ebankcif(
    pec_signchannel varchar2(10) -- 签约渠道
    ,pec_ecifno varchar2(32) -- 全行统一客户号
    ,pec_userno varchar2(32) -- 用户顺序号
    ,pec_loginid varchar2(64) -- 用户登陆名
    ,pec_state varchar2(1) -- 状态
    ,pec_opendate varchar2(14) -- 开户日期
    ,pec_closedate varchar2(14) -- 销户日期
    ,pec_cstlabel varchar2(64) -- 用户标签
    ,pec_cstlogo number(22) -- 头像
    ,pec_protect varchar2(1) -- 敏感标志
    ,pec_pbpausestate varchar2(1) -- 暂停状态
    ,pec_pbpausedate varchar2(14) -- 暂停结束日期
    ,pec_pbpauseenddate varchar2(14) -- 暂停日期
    ,pec_pauseremark varchar2(120) -- 暂停附言
    ,pec_mbpausestate varchar2(1) -- 手机银行暂停状态
    ,pec_mbpausedate varchar2(14) -- 银行暂停开始时间
    ,pec_mobilepauseenddate varchar2(14) -- 手机银行暂停结束时间
    ,pec_mbpauseremark varchar2(120) -- 手机银行暂停使用备注
    ,pec_storageflag varchar2(1) -- 是否为网银存量用户标识位
    ,pec_agreedate varchar2(14) -- 存量用户同意接受手机银行协议日期
    ,pec_eaccsignchannel varchar2(4) -- 电子账户签约渠道
    ,pec_securitytype varchar2(1) -- 安全认证方式
    ,pec_channel varchar2(10) -- 所属渠道
    ,pec_message_open varchar2(8) -- 第一位登录短信开关,第二位隐私提示开关
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_pbs_ebankcif to ${iml_schema};
grant select on ${iol_schema}.osbs_pbs_ebankcif to ${icl_schema};
grant select on ${iol_schema}.osbs_pbs_ebankcif to ${idl_schema};
grant select on ${iol_schema}.osbs_pbs_ebankcif to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_pbs_ebankcif is '个人客户渠道信息';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_signchannel is '签约渠道';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_loginid is '用户登陆名';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_state is '状态';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_opendate is '开户日期';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_closedate is '销户日期';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_cstlabel is '用户标签';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_cstlogo is '头像';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_protect is '敏感标志';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_pbpausestate is '暂停状态';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_pbpausedate is '暂停结束日期';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_pbpauseenddate is '暂停日期';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_pauseremark is '暂停附言';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_mbpausestate is '手机银行暂停状态';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_mbpausedate is '银行暂停开始时间';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_mobilepauseenddate is '手机银行暂停结束时间';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_mbpauseremark is '手机银行暂停使用备注';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_storageflag is '是否为网银存量用户标识位';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_agreedate is '存量用户同意接受手机银行协议日期';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_eaccsignchannel is '电子账户签约渠道';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_securitytype is '安全认证方式';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_channel is '所属渠道';
comment on column ${iol_schema}.osbs_pbs_ebankcif.pec_message_open is '第一位登录短信开关,第二位隐私提示开关';
comment on column ${iol_schema}.osbs_pbs_ebankcif.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_pbs_ebankcif.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_pbs_ebankcif.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_pbs_ebankcif.etl_timestamp is 'ETL处理时间戳';
