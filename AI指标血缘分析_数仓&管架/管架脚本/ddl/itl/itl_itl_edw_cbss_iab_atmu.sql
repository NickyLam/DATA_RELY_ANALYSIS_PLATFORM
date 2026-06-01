/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_cbss_iab_atmu
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_cbss_iab_atmu
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_cbss_iab_atmu purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_cbss_iab_atmu(
    etl_dt date -- 数据日期
    ,atmcod varchar2(15) -- ATM设备号
    ,brchno varchar2(10) -- 所属部门
    ,userid varchar2(10) -- 用户号
    ,csbxno varchar2(6) -- 钱箱号
    ,tmnlno varchar2(20) -- 终端编号
    ,atmtyp varchar2(2) -- ATM类型
    ,atmsts varchar2(1) -- ATM状态
    ,atmmod varchar2(20) -- ATM型号
    ,addres varchar2(60) -- 安装地址
    ,stdate varchar2(8) -- 启用日期
    ,eddate varchar2(8) -- 终止日期
    ,mgname varchar2(20) -- 管理员名
    ,teleno varchar2(20) -- 联系电话
    ,mgmode varchar2(1) -- 管理模式
    ,qjcoid varchar2(4) -- 清机公司编号
    ,qjtsti varchar2(20) -- 清机时间戳
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_cbss_iab_atmu to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_cbss_iab_atmu is 'atm配置表';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.atmcod is 'ATM设备号';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.brchno is '所属部门';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.userid is '用户号';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.csbxno is '钱箱号';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.tmnlno is '终端编号';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.atmtyp is 'ATM类型';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.atmsts is 'ATM状态';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.atmmod is 'ATM型号';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.addres is '安装地址';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.stdate is '启用日期';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.eddate is '终止日期';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.mgname is '管理员名';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.teleno is '联系电话';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.mgmode is '管理模式';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.qjcoid is '清机公司编号';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.qjtsti is '清机时间戳';
comment on column ${itl_schema}.itl_edw_cbss_iab_atmu.etl_timestamp is 'ETL处理时间戳';