/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_ab_auth_tasktabledtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl(
    txdate date -- 交易日期
    ,txtime varchar2(6) -- 交易时间
    ,tradeserno varchar2(24) -- 前台交易流水号
    ,authserno varchar2(30) -- 授权流水号（编号规则：6位日期+10位顺序号）
    ,crtdate varchar2(8) -- 创建日期
    ,txorgno varchar2(6) -- 交易机构号
    ,txtellerno varchar2(50) -- 交易柜员号
    ,authorgno varchar2(6) -- 授权机构号
    ,authtellerno varchar2(50) -- 授权柜员号
    ,auditorgno varchar2(6) -- 复核机构号
    ,audittellerno varchar2(50) -- 复核柜员号
    ,authstatus varchar2(1) -- 远程授权任务状态(1-授权等待中、2-授权处理中、3-授权通过、4-授权拒绝、5-授权返回、6-转现场授权、7-授权撤销、8-异常)
    ,authtasknote varchar2(300) -- 授权任务备注
    ,authrefusenote varchar2(300) -- 授权任务拒绝备注
    ,crttime varchar2(6) -- 创建时间
    ,weight number(2,0) -- 权重值
    ,authmodel varchar2(1) -- 授权模式(0-本地授权、1-跨终端授权、2-远程授权)
    ,isauthflag varchar2(1) -- 是否授权返回（0-否、1-是）
    ,txcode varchar2(8) -- 交易码
    ,reasoncode varchar2(1000) -- 授权原因
    ,barcode varchar2(50) -- 影像码
    ,authlevel varchar2(2) -- 授权级别
    ,tradestatus varchar2(1) -- 交易状态（0-处理中，1-成功，2-失败）
    ,trademode varchar2(1) -- 交易模式（1-单交易模式，2-交易包模式）
    ,authreturnnote varchar2(300) -- 授权退件备注
    ,authcancelnote varchar2(300) -- 授权撤销备注
    ,returntype varchar2(300) -- 授权返回原因码
    ,overtime varchar2(6) -- 数据日期
    ,cartorder number(3,0) -- 提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）
    ,makeupsn varchar2(32) -- 购物车授权任务顺序，从1开始
    ,times number(3,0) -- 购物车组合流水
    ,authnote_replenish varchar2(300) -- 发起补件备注
    ,replenish_status varchar2(1) -- 补件状态
    ,auth_replenish_type varchar2(300) -- 补件退回类型
    ,auth_replenish_note varchar2(300) -- 补件退回备注
    ,bj_tellerno varchar2(50) -- 补件柜员
    ,fqbj_tellerno varchar2(50) -- 发起后补件人员
    ,sh_tellerno varchar2(50) -- 审核授权人员
    ,bj_authtellerno varchar2(50) -- 后补件授权柜员
    ,replenish_note varchar2(300) -- 补件备注
    ,replenishflag varchar2(1) -- 补件标记。1-后补件;0-默认值，原授权任务，非后补件
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl is '授权任务流水表';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.txdate is '交易日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.txtime is '交易时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.tradeserno is '前台交易流水号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authserno is '授权流水号（编号规则：6位日期+10位顺序号）';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.crtdate is '创建日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.txorgno is '交易机构号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.txtellerno is '交易柜员号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authorgno is '授权机构号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authtellerno is '授权柜员号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.auditorgno is '复核机构号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.audittellerno is '复核柜员号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authstatus is '远程授权任务状态(1-授权等待中、2-授权处理中、3-授权通过、4-授权拒绝、5-授权返回、6-转现场授权、7-授权撤销、8-异常)';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authtasknote is '授权任务备注';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authrefusenote is '授权任务拒绝备注';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.crttime is '创建时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.weight is '权重值';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authmodel is '授权模式(0-本地授权、1-跨终端授权、2-远程授权)';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.isauthflag is '是否授权返回（0-否、1-是）';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.txcode is '交易码';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.reasoncode is '授权原因';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.barcode is '影像码';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authlevel is '授权级别';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.tradestatus is '交易状态（0-处理中，1-成功，2-失败）';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.trademode is '交易模式（1-单交易模式，2-交易包模式）';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authreturnnote is '授权退件备注';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authcancelnote is '授权撤销备注';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.returntype is '授权返回原因码';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.overtime is '数据日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.cartorder is '提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.makeupsn is '购物车授权任务顺序，从1开始';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.times is '购物车组合流水';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.authnote_replenish is '发起补件备注';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.replenish_status is '补件状态';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.auth_replenish_type is '补件退回类型';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.auth_replenish_note is '补件退回备注';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.bj_tellerno is '补件柜员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.fqbj_tellerno is '发起后补件人员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.sh_tellerno is '审核授权人员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.bj_authtellerno is '后补件授权柜员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.replenish_note is '补件备注';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.replenishflag is '补件标记。1-后补件;0-默认值，原授权任务，非后补件';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_tasktabledtl.etl_timestamp is 'ETL处理时间戳';