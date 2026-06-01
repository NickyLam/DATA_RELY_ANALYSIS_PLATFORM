/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wmps_tbproductadd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wmps_tbproductadd
whenever sqlerror continue none;
drop table ${iol_schema}.wmps_tbproductadd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wmps_tbproductadd(
    prd_code varchar2(48) -- 产品代码
    ,debt_regist_code varchar2(30) -- 产品中债登记编码
    ,debt_fund_type varchar2(2) -- 中债产品划分:1-普通个人产品、2-高净值产品、3-私行专属、6-机构专属、7-同业专属
    ,benchmark_summary varchar2(4000) -- 业绩基准说明
    ,allow_client_group varchar2(30) -- 允许销售的中债客户组别:1-一般个人客户 2-高资产净值客户 3-私人银行客户 4-银行业金融机构客户 5-非银行业金融机构客户 6-法人机构其他 7-非法人资产管理产品 8-非法人机构其他
    ,ipo_type varchar2(2) -- 产品募集方式:0-公募 1-私募
    ,calm_time number(22,0) -- 冷静期小时
    ,calm_day number(22,0) -- 冷静期天数
    ,calm_optype varchar2(2) -- 冷静期计算方式:0-按理论时间 1-按有效时间
    ,investment_targets varchar2(2) -- 投资标的(投资性质):0-固定收益类 1-权益类 2-商品及金融衍生品类 3-混合类
    ,cltnum_limit_code varchar2(48) -- 产品人数计划代码
    ,cltnum_client_type varchar2(2) -- 人数控制客户类型
    ,last_cycle_date number(22,0) -- 最近周期日期
    ,next_cycle_date number(22,0) -- 下一周期日
    ,last_cfm_date number(22,0) -- 最后确认日期
    ,next_cfm_date number(22,0) -- 下一确认日
    ,prev_month_nav number(18,8) -- 一个月前净值
    ,three_month_nav number(18,8) -- 三月净值盈亏:三个月前净值
    ,six_month_nav number(18,8) -- 半年前净值
    ,prev_year_nav number(18,8) -- 一年前净值
    ,integer1 number(22,0) -- 备用整型1
    ,integer2 number(22,0) -- 备用整型2
    ,amt1 number(18,2) -- 备用金额1
    ,amt2 number(18,2) -- 备用金额2
    ,reserve1 varchar2(375) -- 保留字段1:F18文件业绩比较基准
    ,reserve2 varchar2(375) -- 保留字段2
    ,reserve3 varchar2(375) -- 保留字段3
    ,create_time varchar2(30) -- 创建时间戳:转换费率使用
    ,last_modified_time varchar2(30) -- 修改时间戳:0 年 1月 2元  3日，该字段填单位
    ,version number(22,0) -- 版本号
    ,prd_scale number(18,2) -- 产品总规模
    ,tot_vol number(18,3) -- 总份额
    ,conv_flag varchar2(2) -- 转换标志:[K_ZHBZ] 0\t-\t可转入，可转出 1\t-\t只可转入 2\t-\t只可转出 3\t-\t不可转换
    ,yield number(18,8) -- 七日年化收益率
    ,yield_flag varchar2(2) -- 货币基金七日年化收益率正负:0-正  1-负
    ,annual_rate_date number(22,0) -- 年化收益更新日期
    ,prd_limit_day number(22,0) -- 产品期限
    ,prd_scale_agency number(18,6) -- 产品规模-代销端
    ,cust_manager_no varchar2(150) -- 投资经理编号
    ,access_status varchar2(2) -- 准入状态:法人行产品准入状态 0初始状态 1省准入 2市准入 3法人行准入
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
grant select on ${iol_schema}.wmps_tbproductadd to ${iml_schema};
grant select on ${iol_schema}.wmps_tbproductadd to ${icl_schema};
grant select on ${iol_schema}.wmps_tbproductadd to ${idl_schema};
grant select on ${iol_schema}.wmps_tbproductadd to ${iel_schema};

-- comment
comment on table ${iol_schema}.wmps_tbproductadd is '产品附加信息表';
comment on column ${iol_schema}.wmps_tbproductadd.prd_code is '产品代码';
comment on column ${iol_schema}.wmps_tbproductadd.debt_regist_code is '产品中债登记编码';
comment on column ${iol_schema}.wmps_tbproductadd.debt_fund_type is '中债产品划分:1-普通个人产品、2-高净值产品、3-私行专属、6-机构专属、7-同业专属';
comment on column ${iol_schema}.wmps_tbproductadd.benchmark_summary is '业绩基准说明';
comment on column ${iol_schema}.wmps_tbproductadd.allow_client_group is '允许销售的中债客户组别:1-一般个人客户 2-高资产净值客户 3-私人银行客户 4-银行业金融机构客户 5-非银行业金融机构客户 6-法人机构其他 7-非法人资产管理产品 8-非法人机构其他';
comment on column ${iol_schema}.wmps_tbproductadd.ipo_type is '产品募集方式:0-公募 1-私募';
comment on column ${iol_schema}.wmps_tbproductadd.calm_time is '冷静期小时';
comment on column ${iol_schema}.wmps_tbproductadd.calm_day is '冷静期天数';
comment on column ${iol_schema}.wmps_tbproductadd.calm_optype is '冷静期计算方式:0-按理论时间 1-按有效时间';
comment on column ${iol_schema}.wmps_tbproductadd.investment_targets is '投资标的(投资性质):0-固定收益类 1-权益类 2-商品及金融衍生品类 3-混合类';
comment on column ${iol_schema}.wmps_tbproductadd.cltnum_limit_code is '产品人数计划代码';
comment on column ${iol_schema}.wmps_tbproductadd.cltnum_client_type is '人数控制客户类型';
comment on column ${iol_schema}.wmps_tbproductadd.last_cycle_date is '最近周期日期';
comment on column ${iol_schema}.wmps_tbproductadd.next_cycle_date is '下一周期日';
comment on column ${iol_schema}.wmps_tbproductadd.last_cfm_date is '最后确认日期';
comment on column ${iol_schema}.wmps_tbproductadd.next_cfm_date is '下一确认日';
comment on column ${iol_schema}.wmps_tbproductadd.prev_month_nav is '一个月前净值';
comment on column ${iol_schema}.wmps_tbproductadd.three_month_nav is '三月净值盈亏:三个月前净值';
comment on column ${iol_schema}.wmps_tbproductadd.six_month_nav is '半年前净值';
comment on column ${iol_schema}.wmps_tbproductadd.prev_year_nav is '一年前净值';
comment on column ${iol_schema}.wmps_tbproductadd.integer1 is '备用整型1';
comment on column ${iol_schema}.wmps_tbproductadd.integer2 is '备用整型2';
comment on column ${iol_schema}.wmps_tbproductadd.amt1 is '备用金额1';
comment on column ${iol_schema}.wmps_tbproductadd.amt2 is '备用金额2';
comment on column ${iol_schema}.wmps_tbproductadd.reserve1 is '保留字段1:F18文件业绩比较基准';
comment on column ${iol_schema}.wmps_tbproductadd.reserve2 is '保留字段2';
comment on column ${iol_schema}.wmps_tbproductadd.reserve3 is '保留字段3';
comment on column ${iol_schema}.wmps_tbproductadd.create_time is '创建时间戳:转换费率使用';
comment on column ${iol_schema}.wmps_tbproductadd.last_modified_time is '修改时间戳:0 年 1月 2元  3日，该字段填单位';
comment on column ${iol_schema}.wmps_tbproductadd.version is '版本号';
comment on column ${iol_schema}.wmps_tbproductadd.prd_scale is '产品总规模';
comment on column ${iol_schema}.wmps_tbproductadd.tot_vol is '总份额';
comment on column ${iol_schema}.wmps_tbproductadd.conv_flag is '转换标志:[K_ZHBZ] 0\t-\t可转入，可转出 1\t-\t只可转入 2\t-\t只可转出 3\t-\t不可转换';
comment on column ${iol_schema}.wmps_tbproductadd.yield is '七日年化收益率';
comment on column ${iol_schema}.wmps_tbproductadd.yield_flag is '货币基金七日年化收益率正负:0-正  1-负';
comment on column ${iol_schema}.wmps_tbproductadd.annual_rate_date is '年化收益更新日期';
comment on column ${iol_schema}.wmps_tbproductadd.prd_limit_day is '产品期限';
comment on column ${iol_schema}.wmps_tbproductadd.prd_scale_agency is '产品规模-代销端';
comment on column ${iol_schema}.wmps_tbproductadd.cust_manager_no is '投资经理编号';
comment on column ${iol_schema}.wmps_tbproductadd.access_status is '准入状态:法人行产品准入状态 0初始状态 1省准入 2市准入 3法人行准入';
comment on column ${iol_schema}.wmps_tbproductadd.start_dt is '开始时间';
comment on column ${iol_schema}.wmps_tbproductadd.end_dt is '结束时间';
comment on column ${iol_schema}.wmps_tbproductadd.id_mark is '增删标志';
comment on column ${iol_schema}.wmps_tbproductadd.etl_timestamp is 'ETL处理时间戳';
