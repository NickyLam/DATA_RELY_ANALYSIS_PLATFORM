/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_stat_det_posiiton
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_stat_det_posiiton
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_stat_det_posiiton purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_stat_det_posiiton(
    bookset_id varchar2(50) -- 账套代码
    ,happen_date date -- 发生日期
    ,book_date date -- 入账日期
    ,bok_detail_id varchar2(32) -- 账务明细代码
    ,book_summary_order number(20) -- 处理序列
    ,bookset_date date -- 账套日期
    ,pos_amt number(30,2) -- 当前持仓
    ,int_rate number(30,14) -- 计提利率
    ,dailydsc_yield number(30,14) -- 日摊销收益率
    ,tdy_intincexp_add number(30,2) -- 当日发生应计利息
    ,tdy_intincexp number(30,2) -- 当日累计应计利息余额
    ,finprod_type varchar2(50) -- 金融产品类型
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,chl_id varchar2(32) -- 通道代码
    ,inv_aim varchar2(50) -- 投资目的
    ,tdy_position number(30,14) -- 当日计提份额
    ,tdy_cost_amt number(30,2) -- 当日成本
    ,tdy_float_ingpl number(30,2) -- 当日公允价值变动
    ,end_days_1 number(20) -- 剩余期限
    ,end_days_2 number(20) -- 剩余存续期限
    ,end_days_cost_amt number(30,14) -- 剩余期限用成本
    ,busi_id varchar2(50) -- 业务明细代码
    ,val_date date -- 行情日期
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,tdy_float_ingpl_exp number(30,2) -- 当日累计公允价值变动
    ,ccy varchar2(50) -- 币种
    ,b_ccy varchar2(50) -- 本位币
    ,tdy_intincexp_add_b number(30,2) -- 当日发生应计利息_本位币
    ,tdy_cost_amt_b number(30,2) -- 当日成本_本位币
    ,tdy_float_ingpl_b number(30,2) -- 当日公允价值变动_本位币
    ,tdy_float_ingpl_exp_b number(30,2) -- 当日累计公允价值变动_本位币
    ,tdy_intincexp_b number(30,2) -- 当日累计应计利息余额_本位币
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_bok_stat_det_posiiton to ${iml_schema};
grant select on ${iol_schema}.fams_bok_stat_det_posiiton to ${icl_schema};
grant select on ${iol_schema}.fams_bok_stat_det_posiiton to ${idl_schema};
grant select on ${iol_schema}.fams_bok_stat_det_posiiton to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_stat_det_posiiton is '统计分析明细表（账务明细）';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.happen_date is '发生日期';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.book_date is '入账日期';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.bok_detail_id is '账务明细代码';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.book_summary_order is '处理序列';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.bookset_date is '账套日期';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.pos_amt is '当前持仓';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.int_rate is '计提利率';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.dailydsc_yield is '日摊销收益率';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_intincexp_add is '当日发生应计利息';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_intincexp is '当日累计应计利息余额';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.finprod_type is '金融产品类型';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.vdate is '起息日';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.mdate is '到期日';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.chl_id is '通道代码';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.inv_aim is '投资目的';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_position is '当日计提份额';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_cost_amt is '当日成本';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_float_ingpl is '当日公允价值变动';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.end_days_1 is '剩余期限';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.end_days_2 is '剩余存续期限';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.end_days_cost_amt is '剩余期限用成本';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.busi_id is '业务明细代码';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.val_date is '行情日期';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_float_ingpl_exp is '当日累计公允价值变动';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.ccy is '币种';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.b_ccy is '本位币';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_intincexp_add_b is '当日发生应计利息_本位币';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_cost_amt_b is '当日成本_本位币';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_float_ingpl_b is '当日公允价值变动_本位币';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_float_ingpl_exp_b is '当日累计公允价值变动_本位币';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.tdy_intincexp_b is '当日累计应计利息余额_本位币';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_stat_det_posiiton.etl_timestamp is 'ETL处理时间戳';
