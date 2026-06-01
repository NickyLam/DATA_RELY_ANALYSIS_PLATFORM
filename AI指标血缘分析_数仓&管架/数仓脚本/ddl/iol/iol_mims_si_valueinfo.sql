/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_valueinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_valueinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_valueinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_valueinfo(
    sccode varchar2(48) -- 
    ,evalmode varchar2(3) -- 
    ,evaldate varchar2(15) -- 
    ,curreny varchar2(15) -- 
    ,rate number(18,10) -- 
    ,outevalexpdate varchar2(15) -- 
    ,outevaldeptcode varchar2(450) -- 
    ,outevalmethod varchar2(150) -- 
    ,outevalflag varchar2(2) -- 
    ,outevalamt1 number(20,2) -- 
    ,outevaldate varchar2(15) -- 
    ,outevalamt number(20,2) -- 
    ,evalamt number(20,2) -- 
    ,evalamt2 number(20,2) -- 
    ,businessinsid varchar2(48) -- 
    ,confmamt number(20,2) -- 
    ,condate varchar2(15) -- 
    ,firstoutevalamt number(20,2) -- 
    ,firstevalamt number(20,2) -- 
    ,firstconfmamt number(20,2) -- 
    ,startbusinessinsid varchar2(45) -- 
    ,state varchar2(2) -- 
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
grant select on ${iol_schema}.mims_si_valueinfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_valueinfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_valueinfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_valueinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_valueinfo is '押品价值信息';
comment on column ${iol_schema}.mims_si_valueinfo.sccode is '';
comment on column ${iol_schema}.mims_si_valueinfo.evalmode is '';
comment on column ${iol_schema}.mims_si_valueinfo.evaldate is '';
comment on column ${iol_schema}.mims_si_valueinfo.curreny is '';
comment on column ${iol_schema}.mims_si_valueinfo.rate is '';
comment on column ${iol_schema}.mims_si_valueinfo.outevalexpdate is '';
comment on column ${iol_schema}.mims_si_valueinfo.outevaldeptcode is '';
comment on column ${iol_schema}.mims_si_valueinfo.outevalmethod is '';
comment on column ${iol_schema}.mims_si_valueinfo.outevalflag is '';
comment on column ${iol_schema}.mims_si_valueinfo.outevalamt1 is '';
comment on column ${iol_schema}.mims_si_valueinfo.outevaldate is '';
comment on column ${iol_schema}.mims_si_valueinfo.outevalamt is '';
comment on column ${iol_schema}.mims_si_valueinfo.evalamt is '';
comment on column ${iol_schema}.mims_si_valueinfo.evalamt2 is '';
comment on column ${iol_schema}.mims_si_valueinfo.businessinsid is '';
comment on column ${iol_schema}.mims_si_valueinfo.confmamt is '';
comment on column ${iol_schema}.mims_si_valueinfo.condate is '';
comment on column ${iol_schema}.mims_si_valueinfo.firstoutevalamt is '';
comment on column ${iol_schema}.mims_si_valueinfo.firstevalamt is '';
comment on column ${iol_schema}.mims_si_valueinfo.firstconfmamt is '';
comment on column ${iol_schema}.mims_si_valueinfo.startbusinessinsid is '';
comment on column ${iol_schema}.mims_si_valueinfo.state is '';
comment on column ${iol_schema}.mims_si_valueinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_valueinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_valueinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_valueinfo.etl_timestamp is 'ETL处理时间戳';
