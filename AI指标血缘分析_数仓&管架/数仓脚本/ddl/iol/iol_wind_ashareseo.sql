/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareseo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareseo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareseo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareseo(
    object_id varchar2(150) -- 对象id
    ,s_info_windcode varchar2(60) -- wind代码
    ,s_fellow_progress number(5,0) -- 方案进度
    ,s_fellow_issuetype varchar2(15) -- 发行方式
    ,crncy_code varchar2(15) -- 货币代码
    ,s_fellow_price number(20,4) -- 发行价格(元)
    ,s_fellow_amount number(20,4) -- 发行数量(万股)
    ,s_fellow_collection number(20,4) -- 募集资金(元)
    ,s_fellow_recorddate varchar2(12) -- 股权登记日
    ,s_fellow_paystartdate varchar2(12) -- 向老股东配售(或优先配售)缴款起始日
    ,s_fellow_payenddate varchar2(12) -- 向老股东配售(或优先配售)缴款终止日
    ,s_fellow_subdate varchar2(12) -- 网上申购日
    ,s_fellow_otcdate varchar2(12) -- 股份登记(定向) 日期
    ,s_fellow_listdate varchar2(12) -- 向公众增发股份上市日期
    ,s_fellow_instlistdate varchar2(12) -- 向机构增发股份上市日期
    ,s_fellow_changedate varchar2(12) -- 定向增发股份变动日期
    ,s_fellow_roadshowdate varchar2(12) -- 网上路演日
    ,s_fellow_refunddate varchar2(12) -- 网下申购资金(定金)退款日
    ,s_fellow_unfrozedate varchar2(12) -- 网上申购资金解冻日
    ,s_fellow_preplandate varchar2(12) -- 预案公告日
    ,s_fellow_smtganncedate varchar2(12) -- 股东大会公告日
    ,s_fellow_passdate varchar2(12) -- 发审委通过公告日
    ,s_fellow_approveddate varchar2(15) -- 证监会核准公告日
    ,s_fellow_anncedate varchar2(12) -- 上网发行公告日
    ,s_fellow_ratioanncedate varchar2(12) -- 网上中签率公告日
    ,s_fellow_offeringdate varchar2(12) -- 增发公告日
    ,s_fellow_listanndate varchar2(12) -- 上市公告日
    ,s_fellow_offeringobject varchar2(300) -- 发行对象
    ,s_fellow_priceuplimit number(20,4) -- 增发预案价上限
    ,s_fellow_pricedownlimit number(20,4) -- 增发预案价下限
    ,s_seo_code varchar2(15) -- 增发代码
    ,s_seo_name varchar2(30) -- 增发简称
    ,s_seo_pe number(20,4) -- 发行市盈率(摊薄)
    ,s_seo_amtbyplacing number(20,4) -- 上网发行数量(万股)
    ,s_seo_amttojur number(20,4) -- 网下发行数量(万股)
    ,s_seo_holdersubsmode varchar2(45) -- 大股东认购方式
    ,s_seo_holdersubsrate number(20,4) -- 大股东认购比例(%)
    ,ann_dt varchar2(12) -- 最新公告日期
    ,pricingmode number(9,0) -- 定向增发定价方式代码
    ,s_fellow_orgpricemin number(20,4) -- 原始预案价下限
    ,s_fellow_discntratio number(20,4) -- 折扣率
    ,s_fellow_date varchar2(12) -- 定增发行日期
    ,s_fellow_subinvitationdt varchar2(12) -- 认购邀请书日
    ,s_fellow_year varchar2(12) -- 增发年度
    ,s_fellow_objective_code number(9,0) -- 定向增发目的代码
    ,pricingdate varchar2(12) -- 定价基准日
    ,is_no_public number(5,0) -- 是否属于非公开发行
    ,expense number(20,4) -- 发行费用(元)
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_ashareseo to ${iml_schema};
grant select on ${iol_schema}.wind_ashareseo to ${icl_schema};
grant select on ${iol_schema}.wind_ashareseo to ${idl_schema};
grant select on ${iol_schema}.wind_ashareseo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareseo is '中国A股增发';
comment on column ${iol_schema}.wind_ashareseo.object_id is '对象id';
comment on column ${iol_schema}.wind_ashareseo.s_info_windcode is 'wind代码';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_progress is '方案进度';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_issuetype is '发行方式';
comment on column ${iol_schema}.wind_ashareseo.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_price is '发行价格(元)';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_amount is '发行数量(万股)';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_collection is '募集资金(元)';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_recorddate is '股权登记日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_paystartdate is '向老股东配售(或优先配售)缴款起始日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_payenddate is '向老股东配售(或优先配售)缴款终止日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_subdate is '网上申购日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_otcdate is '股份登记(定向) 日期';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_listdate is '向公众增发股份上市日期';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_instlistdate is '向机构增发股份上市日期';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_changedate is '定向增发股份变动日期';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_roadshowdate is '网上路演日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_refunddate is '网下申购资金(定金)退款日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_unfrozedate is '网上申购资金解冻日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_preplandate is '预案公告日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_smtganncedate is '股东大会公告日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_passdate is '发审委通过公告日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_approveddate is '证监会核准公告日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_anncedate is '上网发行公告日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_ratioanncedate is '网上中签率公告日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_offeringdate is '增发公告日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_listanndate is '上市公告日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_offeringobject is '发行对象';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_priceuplimit is '增发预案价上限';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_pricedownlimit is '增发预案价下限';
comment on column ${iol_schema}.wind_ashareseo.s_seo_code is '增发代码';
comment on column ${iol_schema}.wind_ashareseo.s_seo_name is '增发简称';
comment on column ${iol_schema}.wind_ashareseo.s_seo_pe is '发行市盈率(摊薄)';
comment on column ${iol_schema}.wind_ashareseo.s_seo_amtbyplacing is '上网发行数量(万股)';
comment on column ${iol_schema}.wind_ashareseo.s_seo_amttojur is '网下发行数量(万股)';
comment on column ${iol_schema}.wind_ashareseo.s_seo_holdersubsmode is '大股东认购方式';
comment on column ${iol_schema}.wind_ashareseo.s_seo_holdersubsrate is '大股东认购比例(%)';
comment on column ${iol_schema}.wind_ashareseo.ann_dt is '最新公告日期';
comment on column ${iol_schema}.wind_ashareseo.pricingmode is '定向增发定价方式代码';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_orgpricemin is '原始预案价下限';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_discntratio is '折扣率';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_date is '定增发行日期';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_subinvitationdt is '认购邀请书日';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_year is '增发年度';
comment on column ${iol_schema}.wind_ashareseo.s_fellow_objective_code is '定向增发目的代码';
comment on column ${iol_schema}.wind_ashareseo.pricingdate is '定价基准日';
comment on column ${iol_schema}.wind_ashareseo.is_no_public is '是否属于非公开发行';
comment on column ${iol_schema}.wind_ashareseo.expense is '发行费用(元)';
comment on column ${iol_schema}.wind_ashareseo.opdate is '';
comment on column ${iol_schema}.wind_ashareseo.opmode is '';
comment on column ${iol_schema}.wind_ashareseo.start_dt is '开始时间';
comment on column ${iol_schema}.wind_ashareseo.end_dt is '结束时间';
comment on column ${iol_schema}.wind_ashareseo.id_mark is '增删标志';
comment on column ${iol_schema}.wind_ashareseo.etl_timestamp is 'ETL处理时间戳';
