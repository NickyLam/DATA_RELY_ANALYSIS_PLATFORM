/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scrm_we_flower_customer_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scrm_we_flower_customer_rel
whenever sqlerror continue none;
drop table ${iol_schema}.scrm_we_flower_customer_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_we_flower_customer_rel(
    id varchar2(32) -- 
    ,user_id varchar2(32) -- 客户经理id
    ,qw_user_id varchar2(32) -- 客户经理企微userId
    ,external_userid varchar2(32) -- 客户id
    ,oper_userid varchar2(32) -- 发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid
    ,remark varchar2(100) -- 客户备注（该成员对此外部联系人的备注）
    ,descript varchar2(256) -- 描述（该成员对此外部联系人的描述）
    ,remark_corp_name varchar2(100) -- 该成员对此客户备注的企业名称
    ,remark_mobiles varchar2(255) -- 客户手机号（该成员对此客户备注的手机号码）
    ,add_way varchar2(30) -- 客户来源（该成员添加此客户的来源）
    ,state varchar2(30) -- 企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定
    ,is_open_chat number(22) -- 是否开启会话存档0：关闭1：开启
    ,crm_contr_id varchar2(32) -- 行内联系人id（crm）
    ,crm_contr_nm varchar2(100) -- 行内联系人姓名（crm）
    ,corp_id varchar2(32) -- 
    ,status varchar2(1) -- 状态（1正常 0停用）
    ,create_by varchar2(32) -- 创建人
    ,create_time varchar2(23) -- 创建时间
    ,last_modi_by varchar2(32) -- 最后修改人
    ,last_modi_time varchar2(23) -- 最后修改时间
    ,is_have_xing varchar2(50) -- 是否有星标
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
grant select on ${iol_schema}.scrm_we_flower_customer_rel to ${iml_schema};
grant select on ${iol_schema}.scrm_we_flower_customer_rel to ${icl_schema};
grant select on ${iol_schema}.scrm_we_flower_customer_rel to ${idl_schema};
grant select on ${iol_schema}.scrm_we_flower_customer_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.scrm_we_flower_customer_rel is '客户经理与外部联系人关系表';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.id is '';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.user_id is '客户经理id';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.qw_user_id is '客户经理企微userId';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.external_userid is '客户id';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.oper_userid is '发起添加的userid，如果成员主动添加，为成员的userid；如果是客户主动添加，则为客户的外部联系人userid；如果是内部成员共享/管理员分配，则为对应的成员/管理员userid';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.remark is '客户备注（该成员对此外部联系人的备注）';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.descript is '描述（该成员对此外部联系人的描述）';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.remark_corp_name is '该成员对此客户备注的企业名称';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.remark_mobiles is '客户手机号（该成员对此客户备注的手机号码）';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.add_way is '客户来源（该成员添加此客户的来源）';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.state is '企业自定义的state参数，用于区分客户具体是通过哪个「联系我」添加，由企业通过创建「联系我」方式指定';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.is_open_chat is '是否开启会话存档0：关闭1：开启';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.crm_contr_id is '行内联系人id（crm）';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.crm_contr_nm is '行内联系人姓名（crm）';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.corp_id is '';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.status is '状态（1正常 0停用）';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.create_by is '创建人';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.create_time is '创建时间';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.last_modi_by is '最后修改人';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.last_modi_time is '最后修改时间';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.is_have_xing is '是否有星标';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.start_dt is '开始时间';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.end_dt is '结束时间';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.id_mark is '增删标志';
comment on column ${iol_schema}.scrm_we_flower_customer_rel.etl_timestamp is 'ETL处理时间戳';
