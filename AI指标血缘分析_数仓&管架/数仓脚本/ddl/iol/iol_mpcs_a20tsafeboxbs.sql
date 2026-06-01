/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a20tsafeboxbs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a20tsafeboxbs
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a20tsafeboxbs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a20tsafeboxbs(
    insertdt varchar2(12) -- 登记日期
    ,inserttm varchar2(9) -- 登记时间
    ,operdt varchar2(15) -- 操作日期
    ,id varchar2(150) -- 租约ID
    ,brchno varchar2(15) -- 保管箱所在的网点代码
    ,usercustno varchar2(45) -- 客户号
    ,rentboxdate varchar2(15) -- 租箱日期
    ,rentboxenddt varchar2(15) -- 租箱到期日
    ,sumamt varchar2(45) -- 合计租金
    ,userid varchar2(75) -- 操作员工号
    ,authorid varchar2(75) -- 授权操作员工号
    ,status varchar2(3) -- 租约状态 01正常 04终止（退租）00其他（逾期）
    ,filename varchar2(150) -- 文件名
    ,lineno number(22) -- 行号
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
grant select on ${iol_schema}.mpcs_a20tsafeboxbs to ${iml_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxbs to ${icl_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxbs to ${idl_schema};
grant select on ${iol_schema}.mpcs_a20tsafeboxbs to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a20tsafeboxbs is '保管箱报送流水表';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.insertdt is '登记日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.inserttm is '登记时间';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.operdt is '操作日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.id is '租约ID';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.brchno is '保管箱所在的网点代码';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.usercustno is '客户号';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.rentboxdate is '租箱日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.rentboxenddt is '租箱到期日';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.sumamt is '合计租金';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.userid is '操作员工号';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.authorid is '授权操作员工号';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.status is '租约状态 01正常 04终止（退租）00其他（逾期）';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.filename is '文件名';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.lineno is '行号';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a20tsafeboxbs.etl_timestamp is 'ETL处理时间戳';
