/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_sbxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_sbxx
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_sbxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_sbxx(
    id varchar2(32) -- 主键
    ,sbrq date -- 申报日期
    ,yjse number(22,6) -- 预缴税额
    ,ysxssr number(22,6) -- 应税销售收入
    ,zsxm varchar2(3) -- 税（费）种类
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,sssqq date -- 所属日期起
    ,ybtse number(22,6) -- 应补退税额
    ,sbqx varchar2(10) -- 申报期限
    ,ynse number(22,6) -- 应纳税额
    ,jmse number(22,6) -- 减免税额
    ,sssqz date -- 所属日期止
    ,qbxssr number(22,6) -- 全部销售收入
    ,serno varchar2(32) -- 业务流水号
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
grant select on ${iol_schema}.icms_sxd_company_sbxx to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_sbxx to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_sbxx to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_sbxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_sbxx is '税兴贷企业纳税申报数据';
comment on column ${iol_schema}.icms_sxd_company_sbxx.id is '主键';
comment on column ${iol_schema}.icms_sxd_company_sbxx.sbrq is '申报日期';
comment on column ${iol_schema}.icms_sxd_company_sbxx.yjse is '预缴税额';
comment on column ${iol_schema}.icms_sxd_company_sbxx.ysxssr is '应税销售收入';
comment on column ${iol_schema}.icms_sxd_company_sbxx.zsxm is '税（费）种类';
comment on column ${iol_schema}.icms_sxd_company_sbxx.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_sxd_company_sbxx.sssqq is '所属日期起';
comment on column ${iol_schema}.icms_sxd_company_sbxx.ybtse is '应补退税额';
comment on column ${iol_schema}.icms_sxd_company_sbxx.sbqx is '申报期限';
comment on column ${iol_schema}.icms_sxd_company_sbxx.ynse is '应纳税额';
comment on column ${iol_schema}.icms_sxd_company_sbxx.jmse is '减免税额';
comment on column ${iol_schema}.icms_sxd_company_sbxx.sssqz is '所属日期止';
comment on column ${iol_schema}.icms_sxd_company_sbxx.qbxssr is '全部销售收入';
comment on column ${iol_schema}.icms_sxd_company_sbxx.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_sbxx.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_sbxx.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_sbxx.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_sbxx.etl_timestamp is 'ETL处理时间戳';
