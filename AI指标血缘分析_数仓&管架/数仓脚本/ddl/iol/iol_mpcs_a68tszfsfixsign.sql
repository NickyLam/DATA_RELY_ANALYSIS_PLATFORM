/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a68tszfsfixsign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a68tszfsfixsign
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a68tszfsfixsign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tszfsfixsign(
    unitcd varchar2(21) -- 单位编码
    ,cntrsq varchar2(18) -- 合同序号
    ,citycd varchar2(9) -- 城市编码
    ,cntrtp varchar2(6) -- 合同类型
    ,bustype varchar2(8) -- 业务类型
    ,busno varchar2(18) -- 业务种类
    ,cntrno varchar2(90) -- 协议号
    ,cntrst varchar2(2) -- 协议状态
    ,iotype varchar2(2) -- 往来标志
    ,recvbk varchar2(21) -- 他行网点行号
    ,rebkna varchar2(180) -- 他行网点行名
    ,recvac varchar2(48) -- 他行账号
    ,recvna varchar2(180) -- 他行户名
    ,pyerbk varchar2(21) -- 本行网点行号
    ,pybkna varchar2(180) -- 本行网点行名
    ,pyerac varchar2(48) -- 本行账号
    ,pyerna varchar2(180) -- 本行名称
    ,signdt varchar2(12) -- 签约日期
    ,cncldt varchar2(12) -- 撤销日期
    ,userid varchar2(9) -- 登记柜员
    ,brchno varchar2(9) -- 登记部门
    ,modidt varchar2(21) -- 维护时间
    ,modius varchar2(9) -- 维护柜员
    ,remark varchar2(90) -- 附言
    ,itmscd varchar2(8) -- 费项代码
    ,crcycd varchar2(5) -- 币种
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
grant select on ${iol_schema}.mpcs_a68tszfsfixsign to ${iml_schema};
grant select on ${iol_schema}.mpcs_a68tszfsfixsign to ${icl_schema};
grant select on ${iol_schema}.mpcs_a68tszfsfixsign to ${idl_schema};
grant select on ${iol_schema}.mpcs_a68tszfsfixsign to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a68tszfsfixsign is '深同城定期借贷记签约登记簿';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.unitcd is '单位编码';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.cntrsq is '合同序号';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.citycd is '城市编码';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.cntrtp is '合同类型';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.bustype is '业务类型';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.busno is '业务种类';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.cntrno is '协议号';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.cntrst is '协议状态';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.iotype is '往来标志';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.recvbk is '他行网点行号';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.rebkna is '他行网点行名';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.recvac is '他行账号';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.recvna is '他行户名';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.pyerbk is '本行网点行号';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.pybkna is '本行网点行名';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.pyerac is '本行账号';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.pyerna is '本行名称';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.signdt is '签约日期';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.cncldt is '撤销日期';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.userid is '登记柜员';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.brchno is '登记部门';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.modidt is '维护时间';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.modius is '维护柜员';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.remark is '附言';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.itmscd is '费项代码';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.crcycd is '币种';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a68tszfsfixsign.etl_timestamp is 'ETL处理时间戳';
