/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_sppi_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_sppi_result
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_sppi_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_sppi_result(
    sppi_result_id number(22,0) -- 
    ,cus_num number(5,0) -- 机构代码
    ,aspclient_id number(22,0) -- 部门ID
    ,sppi_type varchar2(2) -- 资产类别 0 表示公共券 9 自定义券 7资产
    ,sppi_code varchar2(24) -- 资产代码
    ,exam_type varchar2(2) -- 0 输入 1导入
    ,write_down varchar2(2) -- 减记条款
    ,equity_swap varchar2(2) -- 转股权
    ,convertible varchar2(2) -- 可调换
    ,abs_abn varchar2(2) -- abs券或abn券
    ,abs_abn_judge varchar2(2) -- absabn人工,a,和BCD互斥。A过了，整个就过了；A没过，bcd全选才能过
    ,abs_abn_a varchar2(2) -- a.在不看穿基础金融工具池的情况下，合同条款可以通过SPPI测试吗？
    ,abs_abn_b varchar2(2) -- b.基础金融工具池至少包含一项工具产生仅为本金及未偿付本金额之利息的支付的现金流量，同时不包含会增加现金流量波动的任何项目
    ,abs_abn_c varchar2(2) -- c.该基础金融工具池的工具在初始确认后会满足b项条件么？
    ,abs_abn_d varchar2(2) -- d.该分级下特有层级的信用风险敞口是否不大于全部基础金融工具池的信用风险敞口？
    ,extend_call_put varchar2(2) -- 展期选择权，可赎回，可回售
    ,extend_call_put_judge varchar2(2) -- 展期选择权，可赎回，可回售人工判断
    ,extend_option varchar2(2) -- 展期选择权
    ,call_option varchar2(2) -- 发行人可赎回权
    ,put_option varchar2(2) -- 投资人可回售权
    ,rate_type varchar2(2) -- 利率方式
    ,rate_type_judge varchar2(2) -- 利率方式人工判断
    ,variable_rate varchar2(2) -- 变动利率相关判断
    ,benchmark varchar2(23) -- 基准利率
    ,benchmark_type varchar2(18) -- 基准利率类别
    ,benchmark_judge varchar2(2) -- 基准利率人工判断
    ,frequency_uniformity varchar2(2) -- 利率调整周期与基准利率期限是否一致
    ,frequency_adj varchar2(3) -- 利率调整周期
    ,benchmark_freq varchar2(3) -- 基准利率期限
    ,frequency_uniformity_judge varchar2(2) -- 利率调整周期与基准利率期限是否一致人工判断
    ,currency_uniformity varchar2(2) -- 本金跟利率是否有相同的货币基础
    ,currency_uniformity_judge varchar2(2) -- 本金跟利率是否有相同的货币基础人工判断
    ,rate_method varchar2(2) -- 重置日计息基准日调整
    ,close_to_start varchar2(2) -- 重置利率起息日与定息日是否相近
    ,close_to_start_judge varchar2(2) -- 重置利率起息日与定息日是否相近人工判断
    ,close_day number(3,0) -- 不超过n个工作日
    ,rate_avg_range varchar2(2) -- 平均利率取值天数是否在预设范围内
    ,rate_avg_rage_judge varchar2(2) -- 平均利率取值天数是否在预设范围内人工判断
    ,rate_avg_day number(3,0) -- 平均利率取值不超过n个工作日
    ,first_result varchar2(2) -- 初步试算结果
    ,final_result varchar2(2) -- 最终测试结果
    ,note varchar2(4000) -- 
    ,modify_date date -- 修改日期
    ,modify_user_id number(5,0) -- 修改人
    ,modify_user_name varchar2(24) -- 修改人名
    ,perpetual varchar2(2) -- 永续债
    ,perpetual_judge varchar2(2) -- 永续债人工判断
    ,test_date number(22,0) -- MODIFY_DATE转换成integer类型，方便使用，eg：20170102
    ,datasymbolconfig_id number(22,0) -- DATASYMBOLCONFIG表中DATASYMBOLCONFIG_ID数据源id
    ,perpetual_method varchar2(2) -- 1.不通过-该债券为权益工具 2.不通过-该债券为债务工具，递延利息不计算利息 3.通过-该债券为债务工具，针对递延利息计算利息
    ,lastmodified timestamp -- 
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
grant select on ${iol_schema}.ctms_sppi_result to ${iml_schema};
grant select on ${iol_schema}.ctms_sppi_result to ${icl_schema};
grant select on ${iol_schema}.ctms_sppi_result to ${idl_schema};
grant select on ${iol_schema}.ctms_sppi_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_sppi_result is '';
comment on column ${iol_schema}.ctms_sppi_result.sppi_result_id is '';
comment on column ${iol_schema}.ctms_sppi_result.cus_num is '机构代码';
comment on column ${iol_schema}.ctms_sppi_result.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_sppi_result.sppi_type is '资产类别 0 表示公共券 9 自定义券 7资产';
comment on column ${iol_schema}.ctms_sppi_result.sppi_code is '资产代码';
comment on column ${iol_schema}.ctms_sppi_result.exam_type is '0 输入 1导入';
comment on column ${iol_schema}.ctms_sppi_result.write_down is '减记条款';
comment on column ${iol_schema}.ctms_sppi_result.equity_swap is '转股权';
comment on column ${iol_schema}.ctms_sppi_result.convertible is '可调换';
comment on column ${iol_schema}.ctms_sppi_result.abs_abn is 'abs券或abn券';
comment on column ${iol_schema}.ctms_sppi_result.abs_abn_judge is 'absabn人工,a,和BCD互斥。A过了，整个就过了；A没过，bcd全选才能过';
comment on column ${iol_schema}.ctms_sppi_result.abs_abn_a is 'a.在不看穿基础金融工具池的情况下，合同条款可以通过SPPI测试吗？';
comment on column ${iol_schema}.ctms_sppi_result.abs_abn_b is 'b.基础金融工具池至少包含一项工具产生仅为本金及未偿付本金额之利息的支付的现金流量，同时不包含会增加现金流量波动的任何项目';
comment on column ${iol_schema}.ctms_sppi_result.abs_abn_c is 'c.该基础金融工具池的工具在初始确认后会满足b项条件么？';
comment on column ${iol_schema}.ctms_sppi_result.abs_abn_d is 'd.该分级下特有层级的信用风险敞口是否不大于全部基础金融工具池的信用风险敞口？';
comment on column ${iol_schema}.ctms_sppi_result.extend_call_put is '展期选择权，可赎回，可回售';
comment on column ${iol_schema}.ctms_sppi_result.extend_call_put_judge is '展期选择权，可赎回，可回售人工判断';
comment on column ${iol_schema}.ctms_sppi_result.extend_option is '展期选择权';
comment on column ${iol_schema}.ctms_sppi_result.call_option is '发行人可赎回权';
comment on column ${iol_schema}.ctms_sppi_result.put_option is '投资人可回售权';
comment on column ${iol_schema}.ctms_sppi_result.rate_type is '利率方式';
comment on column ${iol_schema}.ctms_sppi_result.rate_type_judge is '利率方式人工判断';
comment on column ${iol_schema}.ctms_sppi_result.variable_rate is '变动利率相关判断';
comment on column ${iol_schema}.ctms_sppi_result.benchmark is '基准利率';
comment on column ${iol_schema}.ctms_sppi_result.benchmark_type is '基准利率类别';
comment on column ${iol_schema}.ctms_sppi_result.benchmark_judge is '基准利率人工判断';
comment on column ${iol_schema}.ctms_sppi_result.frequency_uniformity is '利率调整周期与基准利率期限是否一致';
comment on column ${iol_schema}.ctms_sppi_result.frequency_adj is '利率调整周期';
comment on column ${iol_schema}.ctms_sppi_result.benchmark_freq is '基准利率期限';
comment on column ${iol_schema}.ctms_sppi_result.frequency_uniformity_judge is '利率调整周期与基准利率期限是否一致人工判断';
comment on column ${iol_schema}.ctms_sppi_result.currency_uniformity is '本金跟利率是否有相同的货币基础';
comment on column ${iol_schema}.ctms_sppi_result.currency_uniformity_judge is '本金跟利率是否有相同的货币基础人工判断';
comment on column ${iol_schema}.ctms_sppi_result.rate_method is '重置日计息基准日调整';
comment on column ${iol_schema}.ctms_sppi_result.close_to_start is '重置利率起息日与定息日是否相近';
comment on column ${iol_schema}.ctms_sppi_result.close_to_start_judge is '重置利率起息日与定息日是否相近人工判断';
comment on column ${iol_schema}.ctms_sppi_result.close_day is '不超过n个工作日';
comment on column ${iol_schema}.ctms_sppi_result.rate_avg_range is '平均利率取值天数是否在预设范围内';
comment on column ${iol_schema}.ctms_sppi_result.rate_avg_rage_judge is '平均利率取值天数是否在预设范围内人工判断';
comment on column ${iol_schema}.ctms_sppi_result.rate_avg_day is '平均利率取值不超过n个工作日';
comment on column ${iol_schema}.ctms_sppi_result.first_result is '初步试算结果';
comment on column ${iol_schema}.ctms_sppi_result.final_result is '最终测试结果';
comment on column ${iol_schema}.ctms_sppi_result.note is '';
comment on column ${iol_schema}.ctms_sppi_result.modify_date is '修改日期';
comment on column ${iol_schema}.ctms_sppi_result.modify_user_id is '修改人';
comment on column ${iol_schema}.ctms_sppi_result.modify_user_name is '修改人名';
comment on column ${iol_schema}.ctms_sppi_result.perpetual is '永续债';
comment on column ${iol_schema}.ctms_sppi_result.perpetual_judge is '永续债人工判断';
comment on column ${iol_schema}.ctms_sppi_result.test_date is 'MODIFY_DATE转换成integer类型，方便使用，eg：20170102';
comment on column ${iol_schema}.ctms_sppi_result.datasymbolconfig_id is 'DATASYMBOLCONFIG表中DATASYMBOLCONFIG_ID数据源id';
comment on column ${iol_schema}.ctms_sppi_result.perpetual_method is '1.不通过-该债券为权益工具 2.不通过-该债券为债务工具，递延利息不计算利息 3.通过-该债券为债务工具，针对递延利息计算利息';
comment on column ${iol_schema}.ctms_sppi_result.lastmodified is '';
comment on column ${iol_schema}.ctms_sppi_result.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_sppi_result.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_sppi_result.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_sppi_result.etl_timestamp is 'ETL处理时间戳';
