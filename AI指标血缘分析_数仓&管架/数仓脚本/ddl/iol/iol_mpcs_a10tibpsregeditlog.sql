/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a10tibpsregeditlog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a10tibpsregeditlog
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a10tibpsregeditlog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a10tibpsregeditlog(
    function varchar2(30) -- 函数名称
    ,pckno varchar2(30) -- 报文类型
    ,transdt varchar2(12) -- 交易日期--人行日期
    ,businesstrace varchar2(24) -- 业务序号
    ,businessno varchar2(42) -- 报文标识号
    ,transtime varchar2(29) -- 交易时间--登表时间
    ,msgoutbank varchar2(18) -- 发起行号
    ,msginbank varchar2(18) -- 接收行号
    ,functype varchar2(15) -- 业务类型：regedit_注册，dele_注销，anmd_变更账号，damd_变更默认账户属性，sbus_业务状态查询，verify_验证，download_下载
    ,idtype varchar2(6) -- 证件类型
    ,idcode varchar2(105) -- 证件号
    ,dftaccttp varchar2(6) -- 默认账户属性：dflt_默认账户，ndft_非默认账户
    ,rejectbank varchar2(18) -- 开户行所属网银系统行号
    ,acctno varchar2(96) -- 账号
    ,acctname varchar2(180) -- 户名
    ,mskacctname varchar2(180) -- 掩码户名
    ,acctopenbrn varchar2(18) -- 账户开户行
    ,sdficode varchar2(18) -- 账户清算行
    ,tel varchar2(150) -- 手机号
    ,otherid varchar2(150) -- 其他id
    ,remark varchar2(768) -- 备注
    ,canclebanks varchar2(3072) -- 注销的行号列表
    ,newacctno varchar2(96) -- 新账号
    ,newdftaccttp varchar2(6) -- 新账户注册属性
    ,newacctbank varchar2(18) -- 新账户注册属性行号
    ,iotype varchar2(3) -- 往来标志：0_往，1_来
    ,processcode varchar2(6) -- 业务状态
    ,rsrejectcode varchar2(6) -- 业务拒绝码
    ,procdt varchar2(30) -- 人行处理时间
    ,fill varchar2(768) -- 错误信息
    ,status varchar2(3) -- 交易状态：z_初始状态，w_处理中（已发送），f_失败，s_成功，u_未知（超时）
    ,channlid varchar2(15) -- 渠道号
    ,transseqno varchar2(105) -- 渠道流水
    ,otpseqno varchar2(45) -- 短信序列号
    ,orgnlmsgid varchar2(42) -- 原报文标识号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a10tibpsregeditlog to ${iml_schema};
grant select on ${iol_schema}.mpcs_a10tibpsregeditlog to ${icl_schema};
grant select on ${iol_schema}.mpcs_a10tibpsregeditlog to ${idl_schema};
grant select on ${iol_schema}.mpcs_a10tibpsregeditlog to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a10tibpsregeditlog is '客户账户注册流水表';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.function is '函数名称';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.pckno is '报文类型';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.transdt is '交易日期--人行日期';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.businesstrace is '业务序号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.businessno is '报文标识号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.transtime is '交易时间--登表时间';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.msgoutbank is '发起行号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.msginbank is '接收行号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.functype is '业务类型：regedit_注册，dele_注销，anmd_变更账号，damd_变更默认账户属性，sbus_业务状态查询，verify_验证，download_下载';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.idcode is '证件号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.dftaccttp is '默认账户属性：dflt_默认账户，ndft_非默认账户';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.rejectbank is '开户行所属网银系统行号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.acctno is '账号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.acctname is '户名';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.mskacctname is '掩码户名';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.acctopenbrn is '账户开户行';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.sdficode is '账户清算行';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.tel is '手机号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.otherid is '其他id';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.remark is '备注';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.canclebanks is '注销的行号列表';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.newacctno is '新账号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.newdftaccttp is '新账户注册属性';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.newacctbank is '新账户注册属性行号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.iotype is '往来标志：0_往，1_来';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.processcode is '业务状态';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.rsrejectcode is '业务拒绝码';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.procdt is '人行处理时间';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.fill is '错误信息';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.status is '交易状态：z_初始状态，w_处理中（已发送），f_失败，s_成功，u_未知（超时）';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.channlid is '渠道号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.transseqno is '渠道流水';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.otpseqno is '短信序列号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.orgnlmsgid is '原报文标识号';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a10tibpsregeditlog.etl_timestamp is 'ETL处理时间戳';
