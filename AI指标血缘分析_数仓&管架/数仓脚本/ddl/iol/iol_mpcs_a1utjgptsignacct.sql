/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1utjgptsignacct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1utjgptsignacct
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1utjgptsignacct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1utjgptsignacct(
    syscd varchar2(10) -- 系统编号
    ,account varchar2(50) -- 监管账号
    ,accountname varchar2(100) -- 监管账号户名
    ,status varchar2(1) -- 签约状态：0-未签约 1-签约 2-解约
    ,signdate varchar2(8) -- 签约日期
    ,signtime varchar2(10) -- 签约时间
    ,offdate varchar2(8) -- 解约日期
    ,offtime varchar2(10) -- 解约时间
    ,oprbrn varchar2(10) -- 交易机构
    ,oprtlr varchar2(10) -- 交易柜员
    ,chkbrn varchar2(10) -- 复核机构
    ,chktlr varchar2(10) -- 复核柜员
    ,autbrn varchar2(10) -- 授权机构
    ,auttlr varchar2(10) -- 授权柜员
    ,companyname varchar2(200) -- 单位名称
    ,projectname varchar2(200) -- 项目名称
    ,contactnum varchar2(200) -- 联系人
    ,telphome varchar2(300) -- 联系人电话
    ,opbankname varchar2(200) -- 开户行
    ,opbankcode varchar2(30) -- 开户行编码
    ,remarks varchar2(300) -- 备注
    ,accountstatus varchar2(2) -- 监管状态:0_预监管 1_监管中 2_解除监管
    ,errmsg varchar2(50) -- 错误信息
    ,sndflag varchar2(2) -- 发送状态 0-已发送 1-未发送 2-待重发 *-全部
    ,returncode varchar2(3) -- 表示操作结果信息 100:操作成功 101:操作失败 99:系统错误
    ,reason varchar2(200) -- 返回信息
    ,openbrn varchar2(6) -- 开户机构
    ,historicalflag varchar2(2) -- 历史数据标志：0_不用 1_需要
    ,opendate varchar2(10) -- 开户日期
    ,xzqhbm varchar2(6) -- 行政区划编码
    ,updt varchar2(14) -- 最后修改时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a1utjgptsignacct to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1utjgptsignacct to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1utjgptsignacct to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1utjgptsignacct to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1utjgptsignacct is '签约信息表';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.syscd is '系统编号';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.account is '监管账号';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.accountname is '监管账号户名';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.status is '签约状态：0-未签约 1-签约 2-解约';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.signdate is '签约日期';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.signtime is '签约时间';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.offdate is '解约日期';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.offtime is '解约时间';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.oprbrn is '交易机构';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.oprtlr is '交易柜员';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.chkbrn is '复核机构';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.chktlr is '复核柜员';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.autbrn is '授权机构';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.auttlr is '授权柜员';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.companyname is '单位名称';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.projectname is '项目名称';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.contactnum is '联系人';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.telphome is '联系人电话';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.opbankname is '开户行';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.opbankcode is '开户行编码';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.remarks is '备注';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.accountstatus is '监管状态:0_预监管 1_监管中 2_解除监管';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.sndflag is '发送状态 0-已发送 1-未发送 2-待重发 *-全部';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.returncode is '表示操作结果信息 100:操作成功 101:操作失败 99:系统错误';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.reason is '返回信息';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.openbrn is '开户机构';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.historicalflag is '历史数据标志：0_不用 1_需要';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.opendate is '开户日期';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.xzqhbm is '行政区划编码';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.updt is '最后修改时间';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1utjgptsignacct.etl_timestamp is 'ETL处理时间戳';
