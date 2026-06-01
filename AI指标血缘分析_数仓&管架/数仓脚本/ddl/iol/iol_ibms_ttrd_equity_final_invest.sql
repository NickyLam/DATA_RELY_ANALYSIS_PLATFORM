/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_equity_final_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_equity_final_invest
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_equity_final_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity_final_invest(
    id number(22,0) -- 序号
    ,ratio_id number(22,0) -- 占比id
    ,i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(45) -- 资产大类
    ,m_type varchar2(45) -- 市场类型
    ,final_invest_type varchar2(450) -- 最终投向类型（穿透底层）
    ,invest_ratio number(31,6) -- 当期投资金额占比(%)
    ,grade varchar2(75) -- 评级（金融债权为主体评级/非金融债权为债项评级）
    ,low_prop number(31,6) -- 合同中的最低投资比例(%)
    ,high_prop number(31,6) -- 合同中的最高投资比例(%)
    ,weight number(31,6) -- 权重(%)
    ,remark varchar2(750) -- 备注
    ,date_explain varchar2(450) -- 数据项说明
    ,asset_class varchar2(75) -- 映射资本新规基础资产品种或资产中类
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
grant select on ${iol_schema}.ibms_ttrd_equity_final_invest to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_final_invest to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_final_invest to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_final_invest to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_equity_final_invest is '最终投向类型表';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.id is '序号';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.ratio_id is '占比id';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.a_type is '资产大类';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.final_invest_type is '最终投向类型（穿透底层）';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.invest_ratio is '当期投资金额占比(%)';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.grade is '评级（金融债权为主体评级/非金融债权为债项评级）';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.low_prop is '合同中的最低投资比例(%)';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.high_prop is '合同中的最高投资比例(%)';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.weight is '权重(%)';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.date_explain is '数据项说明';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.asset_class is '映射资本新规基础资产品种或资产中类';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest.etl_timestamp is 'ETL处理时间戳';
