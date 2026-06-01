/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_mulguarwarrantsprocess
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_mulguarwarrantsprocess
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_mulguarwarrantsprocess purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_mulguarwarrantsprocess(
    businessinsid varchar2(45) -- 业务实例id
    ,types varchar2(2) -- 类型1-临时出库 2-续借 3-归还 4-正常出库
    ,principal varchar2(45) -- 权证临时借用人名称
    ,bowreasontype varchar2(3) -- 权证临时出库/续期原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
    ,bowreason varchar2(750) -- 权证临时出库/续期具体原因
    ,accbackdate varchar2(15) -- 权证预计归还日期
    ,opertor varchar2(30) -- 经办人
    ,deptcode varchar2(30) -- 所属机构
    ,operdate varchar2(15) -- 经办日期
    ,ischange varchar2(2) -- 权证信息是否发生变化权证临时出库归还1是0否
    ,changetype varchar2(3) -- 权证信息变化情况01-权证表面信息改变 02-权证类型改变 03-其他
    ,changeinfo varchar2(750) -- 权证信息变化情况描述权证临时出库归还
    ,newwarrantsno varchar2(300) -- 新权利凭证号权证临时出库归还
    ,outgoingtype varchar2(30) -- 权证正常出库原因01-部分押品出库 02-存单兑付出库 03-业务结清且提前出库 04-业务结清且授信到期出库
    ,outgoingreason varchar2(750) -- 权证正常出库具体原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他
    ,reamark varchar2(4000) -- 备注
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
grant select on ${iol_schema}.mims_si_mulguarwarrantsprocess to ${iml_schema};
grant select on ${iol_schema}.mims_si_mulguarwarrantsprocess to ${icl_schema};
grant select on ${iol_schema}.mims_si_mulguarwarrantsprocess to ${idl_schema};
grant select on ${iol_schema}.mims_si_mulguarwarrantsprocess to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_mulguarwarrantsprocess is '押品权证管理过程批量保存信息表';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.businessinsid is '业务实例id';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.types is '类型1-临时出库 2-续借 3-归还 4-正常出库';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.principal is '权证临时借用人名称';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.bowreasontype is '权证临时出库/续期原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.bowreason is '权证临时出库/续期具体原因';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.accbackdate is '权证预计归还日期';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.opertor is '经办人';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.deptcode is '所属机构';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.operdate is '经办日期';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.ischange is '权证信息是否发生变化权证临时出库归还1是0否';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.changetype is '权证信息变化情况01-权证表面信息改变 02-权证类型改变 03-其他';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.changeinfo is '权证信息变化情况描述权证临时出库归还';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.newwarrantsno is '新权利凭证号权证临时出库归还';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.outgoingtype is '权证正常出库原因01-部分押品出库 02-存单兑付出库 03-业务结清且提前出库 04-业务结清且授信到期出库';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.outgoingreason is '权证正常出库具体原因01-	权证借出 02-	权证更换 03-借新还旧 04-其他';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.reamark is '备注';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_mulguarwarrantsprocess.etl_timestamp is 'ETL处理时间戳';
