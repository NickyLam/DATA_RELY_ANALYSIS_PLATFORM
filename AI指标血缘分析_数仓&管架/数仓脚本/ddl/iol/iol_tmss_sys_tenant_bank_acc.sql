/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tmss_sys_tenant_bank_acc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tmss_sys_tenant_bank_acc
whenever sqlerror continue none;
drop table ${iol_schema}.tmss_sys_tenant_bank_acc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_tenant_bank_acc(
    id varchar2(144) -- 主键id
    ,tenant_id varchar2(144) -- 客户ID
    ,tenant_code varchar2(225) -- 客户号(租户号)
    ,bank_acc_no varchar2(450) -- 银行账号
    ,bank_acc_name varchar2(450) -- 账户名称
    ,bank_code varchar2(90) -- 账户机构代码
    ,bank_name varchar2(450) -- 账户机构名称
    ,cur_code varchar2(14) -- 币种
    ,acc_type varchar2(9) -- 账户类别 01活期、02定期、03贷款户、04保证金、05专用户、06通知、07协定、09虚拟户、10活期（票据专户）
    ,acc_nature varchar2(23) -- 账户性质 0001基础户、0002临时户、0003专用户、0004一般户
    ,acc_attribute varchar2(9) -- 账户属性 01总账户、02综合户、03收入户、04支出户、05监控户
    ,status number(3,0) -- 状态 0解挂 1加挂
    ,sign_date date -- 加挂时间
    ,un_sign_date date -- 解挂时间
    ,create_date date -- 创建时间
    ,create_by varchar2(144) -- 创建人
    ,update_date date -- 更新时间
    ,update_by varchar2(144) -- 更新人
    ,corp_code varchar2(225) -- 成员企业编码
    ,corp_name varchar2(225) -- 成员企业名称
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
grant select on ${iol_schema}.tmss_sys_tenant_bank_acc to ${iml_schema};
grant select on ${iol_schema}.tmss_sys_tenant_bank_acc to ${icl_schema};
grant select on ${iol_schema}.tmss_sys_tenant_bank_acc to ${idl_schema};
grant select on ${iol_schema}.tmss_sys_tenant_bank_acc to ${iel_schema};

-- comment
comment on table ${iol_schema}.tmss_sys_tenant_bank_acc is '客户加挂账号表';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.id is '主键id';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.tenant_id is '客户ID';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.tenant_code is '客户号(租户号)';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.bank_acc_no is '银行账号';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.bank_acc_name is '账户名称';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.bank_code is '账户机构代码';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.bank_name is '账户机构名称';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.cur_code is '币种';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.acc_type is '账户类别 01活期、02定期、03贷款户、04保证金、05专用户、06通知、07协定、09虚拟户、10活期（票据专户）';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.acc_nature is '账户性质 0001基础户、0002临时户、0003专用户、0004一般户';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.acc_attribute is '账户属性 01总账户、02综合户、03收入户、04支出户、05监控户';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.status is '状态 0解挂 1加挂';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.sign_date is '加挂时间';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.un_sign_date is '解挂时间';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.create_date is '创建时间';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.create_by is '创建人';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.update_date is '更新时间';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.update_by is '更新人';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.corp_code is '成员企业编码';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.corp_name is '成员企业名称';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.start_dt is '开始时间';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.end_dt is '结束时间';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.id_mark is '增删标志';
comment on column ${iol_schema}.tmss_sys_tenant_bank_acc.etl_timestamp is 'ETL处理时间戳';
