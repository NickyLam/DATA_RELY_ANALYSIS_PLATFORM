/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_aodtips_gkzjdhwh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_aodtips_gkzjdhwh
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_aodtips_gkzjdhwh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_aodtips_gkzjdhwh(
    fundtype varchar2(96) -- 资金类型
    ,payacc varchar2(53) -- 付款人账号
    ,payname varchar2(192) -- 付款人名称
    ,paybankacc varchar2(96) -- 付款行行号
    ,paybankname varchar2(384) -- 付款行行名
    ,proceedsacc varchar2(53) -- 收款人账号
    ,proceedsname varchar2(192) -- 收款人名称
    ,proceedsbankacc varchar2(96) -- 收款行行号
    ,proceedsbankname varchar2(384) -- 收款行行名
    ,postscriptcontent varchar2(300) -- 附言
    ,teller_no varchar2(15) -- 变更柜员
    ,brchno varchar2(15) -- 变更机构
    ,adddata varchar2(30) -- 变更日期
    ,addtime varchar2(30) -- 变更时间
    ,fuyanmodel varchar2(6) -- 附言模板
    ,fuyanshili varchar2(384) -- 附言示例
    ,model varchar2(300) -- 模板格式
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
grant select on ${iol_schema}.mpcs_aodtips_gkzjdhwh to ${iml_schema};
grant select on ${iol_schema}.mpcs_aodtips_gkzjdhwh to ${icl_schema};
grant select on ${iol_schema}.mpcs_aodtips_gkzjdhwh to ${idl_schema};
grant select on ${iol_schema}.mpcs_aodtips_gkzjdhwh to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_aodtips_gkzjdhwh is 'TIPS国库资金划拨信息表';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.fundtype is '资金类型';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.payacc is '付款人账号';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.paybankacc is '付款行行号';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.paybankname is '付款行行名';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.proceedsacc is '收款人账号';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.proceedsname is '收款人名称';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.proceedsbankacc is '收款行行号';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.proceedsbankname is '收款行行名';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.postscriptcontent is '附言';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.teller_no is '变更柜员';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.brchno is '变更机构';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.adddata is '变更日期';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.addtime is '变更时间';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.fuyanmodel is '附言模板';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.fuyanshili is '附言示例';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.model is '模板格式';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_aodtips_gkzjdhwh.etl_timestamp is 'ETL处理时间戳';
