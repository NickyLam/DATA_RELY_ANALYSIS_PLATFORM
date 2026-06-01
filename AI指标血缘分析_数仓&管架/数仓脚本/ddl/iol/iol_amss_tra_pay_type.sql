/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_tra_pay_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_tra_pay_type
whenever sqlerror continue none;
drop table ${iol_schema}.amss_tra_pay_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_tra_pay_type(
    pay_type_id number(10,0) -- 类型ID.
    ,pay_type_name varchar2(64) -- 类型名称.
    ,api_code varchar2(64) -- 接口编码.关联支付接口表的API_CODE字段
    ,pay_center_id number(10,0) -- 支付中心ID.
    ,data_source number(4,0) -- 数据来源.1:界面录入,2:基础资料导入导出:3:数据迁移
    ,remark varchar2(256) -- 备注.
    ,create_user number(10,0) -- 创建用户.
    ,create_emp varchar2(32) -- 创建人.
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,cost_calculation_rules number(4,0) -- 成本手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总
    ,bill_calculation_rules number(4,0) -- 商户手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总,
    ,deprecated number(1,0) -- 是否弃用 0/null 否  1是
    ,priority number(10,0) -- 支付优先级.
    ,update_emp varchar2(32) -- 更新人.
    ,fld_n1 number(10,0) -- 
    ,fld_n2 number(10,0) -- 
    ,fld_n3 number(10,0) -- 
    ,fld_n4 number(10,0) -- 
    ,fld_n5 number(10,0) -- 
    ,fld_s1 varchar2(512) -- 
    ,fld_s2 varchar2(513) -- 
    ,fld_s3 varchar2(514) -- 
    ,fld_s4 varchar2(515) -- 
    ,fld_s5 varchar2(516) -- 
    ,is_allow_activate number(10,0) -- 是否允许激活,0:不允许,1:允许 默认允许
    ,product_type number(4,0) -- 产品分类,详见系统类型PRODUCT_TYPE
    ,pay_accept_org varchar2(32) -- 所属受理机构号
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
grant select on ${iol_schema}.amss_tra_pay_type to ${iml_schema};
grant select on ${iol_schema}.amss_tra_pay_type to ${icl_schema};
grant select on ${iol_schema}.amss_tra_pay_type to ${idl_schema};
grant select on ${iol_schema}.amss_tra_pay_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_tra_pay_type is '支付类型表';
comment on column ${iol_schema}.amss_tra_pay_type.pay_type_id is '类型ID.';
comment on column ${iol_schema}.amss_tra_pay_type.pay_type_name is '类型名称.';
comment on column ${iol_schema}.amss_tra_pay_type.api_code is '接口编码.关联支付接口表的API_CODE字段';
comment on column ${iol_schema}.amss_tra_pay_type.pay_center_id is '支付中心ID.';
comment on column ${iol_schema}.amss_tra_pay_type.data_source is '数据来源.1:界面录入,2:基础资料导入导出:3:数据迁移';
comment on column ${iol_schema}.amss_tra_pay_type.remark is '备注.';
comment on column ${iol_schema}.amss_tra_pay_type.create_user is '创建用户.';
comment on column ${iol_schema}.amss_tra_pay_type.create_emp is '创建人.';
comment on column ${iol_schema}.amss_tra_pay_type.create_time is '创建时间.';
comment on column ${iol_schema}.amss_tra_pay_type.update_time is '更新时间.';
comment on column ${iol_schema}.amss_tra_pay_type.cost_calculation_rules is '成本手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总';
comment on column ${iol_schema}.amss_tra_pay_type.bill_calculation_rules is '商户手续费计算规则.1:逐笔四舍五入汇总,2:逐笔保留6位后汇总舍位,3:逐笔保留6位后汇总四舍五入,4:汇总四舍五入汇总,';
comment on column ${iol_schema}.amss_tra_pay_type.deprecated is '是否弃用 0/null 否  1是';
comment on column ${iol_schema}.amss_tra_pay_type.priority is '支付优先级.';
comment on column ${iol_schema}.amss_tra_pay_type.update_emp is '更新人.';
comment on column ${iol_schema}.amss_tra_pay_type.fld_n1 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_n2 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_n3 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_n4 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_n5 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_s1 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_s2 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_s3 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_s4 is '';
comment on column ${iol_schema}.amss_tra_pay_type.fld_s5 is '';
comment on column ${iol_schema}.amss_tra_pay_type.is_allow_activate is '是否允许激活,0:不允许,1:允许 默认允许';
comment on column ${iol_schema}.amss_tra_pay_type.product_type is '产品分类,详见系统类型PRODUCT_TYPE';
comment on column ${iol_schema}.amss_tra_pay_type.pay_accept_org is '所属受理机构号';
comment on column ${iol_schema}.amss_tra_pay_type.start_dt is '开始时间';
comment on column ${iol_schema}.amss_tra_pay_type.end_dt is '结束时间';
comment on column ${iol_schema}.amss_tra_pay_type.id_mark is '增删标志';
comment on column ${iol_schema}.amss_tra_pay_type.etl_timestamp is 'ETL处理时间戳';
