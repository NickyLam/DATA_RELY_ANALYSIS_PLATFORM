/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_valdistrbyasscont_temp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_valdistrbyasscont_temp
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_valdistrbyasscont_temp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_valdistrbyasscont_temp(
    workdate varchar2(15) -- 供数日期
    ,sccode varchar2(48) -- 押品编号
    ,asscontno varchar2(75) -- 担保合同号
    ,currency varchar2(5) -- 币种
    ,confmamt number(20,2) -- 我行确认价值
    ,assamt number(16,2) -- 押品的担保金额(元)
    ,totalassamt number(20,2) -- 押品担保金额汇总（元）
    ,distriamt number(20,2) -- 分配价值(与我行认定价值币种一样)
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
grant select on ${iol_schema}.mims_yp_valdistrbyasscont_temp to ${iml_schema};
grant select on ${iol_schema}.mims_yp_valdistrbyasscont_temp to ${icl_schema};
grant select on ${iol_schema}.mims_yp_valdistrbyasscont_temp to ${idl_schema};
grant select on ${iol_schema}.mims_yp_valdistrbyasscont_temp to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_valdistrbyasscont_temp is '押品价值按担保合同分配结果表';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.workdate is '供数日期';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.asscontno is '担保合同号';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.currency is '币种';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.confmamt is '我行确认价值';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.assamt is '押品的担保金额(元)';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.totalassamt is '押品担保金额汇总（元）';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.distriamt is '分配价值(与我行认定价值币种一样)';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_valdistrbyasscont_temp.etl_timestamp is 'ETL处理时间戳';
