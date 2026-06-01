/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_rep_prod_reddue_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_rep_prod_reddue_detail
whenever sqlerror continue none;
drop table ${iol_schema}.fams_rep_prod_reddue_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_prod_reddue_detail(
    cdate date -- 日期
    ,prodid varchar2(50) -- 产品标识
    ,prodcode varchar2(50) -- 产品代码
    ,prodname varchar2(200) -- 产品简称
    ,profittype varchar2(50) -- 收益类型代码
    ,profittype_name varchar2(200) -- 收益类型标识
    ,prodseries varchar2(50) -- 系列代码
    ,prodseries_name varchar2(200) -- 系列名称
    ,invnature varchar2(50) -- 投资性质代码
    ,invnature_name varchar2(200) -- 投资性质名称
    ,operatemode varchar2(50) -- 运行方式代码
    ,operatemode_name varchar2(200) -- 运行方式名称
    ,periodid varchar2(50) -- 期次代码
    ,vdate varchar2(50) -- 起息日
    ,mdate varchar2(50) -- 到期日
    ,term varchar2(50) -- 期限（天）
    ,dueamt number(30,2) -- 到期兑付本金（元）
    ,dueqty number(30,2) -- 总份额（元）
    ,actamt number(30,2) -- 实际兑付金额（元）
    ,jtglfl number(30,2) -- 计提固定管理费率%
    ,yjbjjz number(30,2) -- 业绩比较基准%
    ,ratelower number(30,2) -- 业绩比较基准下限%
    ,ratelimit number(30,2) -- 业绩比较基准上限%
    ,baserule varchar2(50) -- 业绩比较基准
    ,yieldtermbef number(30,2) -- 产品实际运作业绩%
    ,yieldterm number(30,2) -- 兑付客户年化收益率%（回补后）
    ,clawamt number(30,2) -- 减免管理费（元）
    ,glfzfamt number(30,2) -- 实收管理费（已支付）
    ,jtglfamt number(30,2) -- 实收管理费（未支付）
    ,ssglfl number(30,2) -- 实收固定管理费率%
    ,ceglfl number(30,2) -- 实收超额管理费率%
    ,sqglfl number(30,2) -- 实际收取管理费率%
    ,manager varchar2(50) -- 投资经理
    ,remark varchar2(50) -- 备注
    ,is_private_prod varchar2(50) -- 是否私行客户
    ,privateprod_flag varchar2(50) -- 私行客户标识
    ,is_cust_prod varchar2(50) -- 是否定制产品
    ,custprod_flag varchar2(50) -- 定制产品标识
    ,custprodtype varchar2(50) -- 定制产品代码
    ,custprodtype_name varchar2(50) -- 定制产品标识
    ,is_min_hold_period varchar2(50) -- 是否最短持有期产品
    ,minholdperiod_flag varchar2(50) -- 最短持有期产品标识
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_rep_prod_reddue_detail to ${iml_schema};
grant select on ${iol_schema}.fams_rep_prod_reddue_detail to ${icl_schema};
grant select on ${iol_schema}.fams_rep_prod_reddue_detail to ${idl_schema};
grant select on ${iol_schema}.fams_rep_prod_reddue_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_rep_prod_reddue_detail is '报表单据-理财产品赎回到期管理报表';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.cdate is '日期';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.prodid is '产品标识';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.prodcode is '产品代码';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.prodname is '产品简称';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.profittype is '收益类型代码';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.profittype_name is '收益类型标识';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.prodseries is '系列代码';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.prodseries_name is '系列名称';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.invnature is '投资性质代码';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.invnature_name is '投资性质名称';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.operatemode is '运行方式代码';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.operatemode_name is '运行方式名称';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.periodid is '期次代码';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.vdate is '起息日';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.mdate is '到期日';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.term is '期限（天）';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.dueamt is '到期兑付本金（元）';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.dueqty is '总份额（元）';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.actamt is '实际兑付金额（元）';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.jtglfl is '计提固定管理费率%';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.yjbjjz is '业绩比较基准%';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.ratelower is '业绩比较基准下限%';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.ratelimit is '业绩比较基准上限%';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.baserule is '业绩比较基准';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.yieldtermbef is '产品实际运作业绩%';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.yieldterm is '兑付客户年化收益率%（回补后）';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.clawamt is '减免管理费（元）';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.glfzfamt is '实收管理费（已支付）';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.jtglfamt is '实收管理费（未支付）';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.ssglfl is '实收固定管理费率%';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.ceglfl is '实收超额管理费率%';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.sqglfl is '实际收取管理费率%';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.manager is '投资经理';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.remark is '备注';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.is_private_prod is '是否私行客户';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.privateprod_flag is '私行客户标识';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.is_cust_prod is '是否定制产品';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.custprod_flag is '定制产品标识';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.custprodtype is '定制产品代码';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.custprodtype_name is '定制产品标识';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.is_min_hold_period is '是否最短持有期产品';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.minholdperiod_flag is '最短持有期产品标识';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.create_user is '创建人';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.create_dept is '创建部门';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.create_time is '创建时间';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.update_user is '更新人';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.update_time is '更新时间';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.start_dt is '开始时间';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.end_dt is '结束时间';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.id_mark is '增删标志';
comment on column ${iol_schema}.fams_rep_prod_reddue_detail.etl_timestamp is 'ETL处理时间戳';
