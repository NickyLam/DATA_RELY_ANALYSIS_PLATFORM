/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareipo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareipo
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareipo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareipo(
    object_id varchar2(150) -- 对象id
    ,s_info_windcode varchar2(60) -- wind代码
    ,crncy_code varchar2(15) -- 货币代码
    ,s_ipo_price number(20,4) -- 发行价格(元)
    ,s_ipo_pre_dilutedpe number(20,4) -- 发行市盈率(发行前股本)
    ,s_ipo_dilutedpe number(20,4) -- 发行市盈率(发行后股本)
    ,s_ipo_amount number(20,4) -- 发行数量(万股)
    ,s_ipo_amtbyplacing number(20,4) -- 网上发行数量(万股)
    ,s_ipo_amttojur number(20,4) -- 网下发行数量(万股)
    ,s_ipo_collection number(20,4) -- 募集资金(万元)
    ,s_ipo_cashratio number(20,8) -- 网上发行中签率(%)
    ,s_ipo_purchasecode varchar2(15) -- 网上申购代码
    ,s_ipo_subdate varchar2(12) -- 申购日
    ,s_ipo_jurisdate varchar2(12) -- 向一般法人配售上市日期
    ,s_ipo_instisdate varchar2(12) -- 向战略投资者配售部分上市日期
    ,s_ipo_expectlistdate varchar2(12) -- 预计上市日期
    ,s_ipo_fundverificationdate varchar2(12) -- 申购资金验资日
    ,s_ipo_ratiodate varchar2(12) -- 中签率公布日
    ,s_fellow_unfrozedate varchar2(12) -- 申购资金解冻日
    ,s_ipo_listdate varchar2(12) -- 上市日
    ,s_ipo_puboffrdate varchar2(12) -- 招股公告日
    ,s_ipo_anncedate varchar2(12) -- 发行公告日
    ,s_ipo_anncelstdate varchar2(12) -- 上市公告日
    ,s_ipo_roadshowstartdate varchar2(12) -- 初步询价(预路演)起始日期
    ,s_ipo_roadshowenddate varchar2(12) -- 初步询价(预路演)终止日期
    ,s_ipo_placingdate varchar2(12) -- 网下配售发行公告日
    ,s_ipo_applystartdate varchar2(12) -- 网下申购起始日期
    ,s_ipo_applyenddate varchar2(12) -- 网下申购截止日期
    ,s_ipo_priceannouncedate varchar2(12) -- 网下定价公告日
    ,s_ipo_placingresultdate varchar2(12) -- 网下配售结果公告日
    ,s_ipo_fundenddate varchar2(12) -- 网下申购资金到帐截止日
    ,s_ipo_capverificationdate varchar2(12) -- 网下验资日
    ,s_ipo_refunddate varchar2(12) -- 网下多余款项退还日
    ,s_ipo_expectedcollection number(20,4) -- 预计募集资金(万元)
    ,s_ipo_list_fee number(20,4) -- 发行费用(万元)
    ,s_ipo_lpurnameonl varchar2(30) -- 
    ,s_ipo_cashamtuplimit number(10,0) -- 申购上限(机构)
    ,s_ipo_cashmoneyuplimit number(20,4) -- 申购金额上限(机构)
    ,s_ipo_namebyplacing varchar2(30) -- 上网发行简称
    ,s_ipo_showpricedownlimit number(20,4) -- 投标询价申购价格下限
    ,s_ipo_par number(24,12) -- 面值
    ,s_ipo_purchaseuplimit number(20,4) -- 网上申购上限(个人)
    ,s_ipo_op_uplimit number(20,4) -- 网下申购上限
    ,s_ipo_op_downlimit number(20,4) -- 网下申购下限
    ,s_ipo_purchasemv_dt varchar2(12) -- 网上市值申购登记日
    ,s_ipo_pubosdtotisscoll number(20,4) -- 公开及原股东募集资金总额
    ,s_ipo_osdexpoffamount number(20,4) -- 新股发行数量
    ,s_ipo_osdexpoffamountup number(20,4) -- 原股东预计售股数量上限
    ,s_ipo_osdactoffamount number(20,4) -- 原股东实际售股数量
    ,s_ipo_osdactoffprice number(20,4) -- 原股东实际售股金额
    ,s_ipo_osdunderwritingfees number(20,4) -- 原股东应摊承销费用
    ,s_ipo_pureffsubratio number(20,4) -- 网上投资者有效认购倍数
    ,s_ipo_reporate number(20,4) -- 回拨比例
    ,ann_dt varchar2(12) -- 最新公告日期
    ,is_failure number(5,0) -- 是否发行失败
    ,s_ipo_otc_cash_pct number(24,8) -- 网下申购配售比例
    ,min_applyunit number(20,4) -- 
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
grant select on ${iol_schema}.wind_ashareipo to ${iml_schema};
grant select on ${iol_schema}.wind_ashareipo to ${icl_schema};
grant select on ${iol_schema}.wind_ashareipo to ${idl_schema};
grant select on ${iol_schema}.wind_ashareipo to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareipo is '中国A股首次公开发行数据';
comment on column ${iol_schema}.wind_ashareipo.object_id is '对象id';
comment on column ${iol_schema}.wind_ashareipo.s_info_windcode is 'wind代码';
comment on column ${iol_schema}.wind_ashareipo.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_price is '发行价格(元)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_pre_dilutedpe is '发行市盈率(发行前股本)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_dilutedpe is '发行市盈率(发行后股本)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_amount is '发行数量(万股)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_amtbyplacing is '网上发行数量(万股)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_amttojur is '网下发行数量(万股)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_collection is '募集资金(万元)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_cashratio is '网上发行中签率(%)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_purchasecode is '网上申购代码';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_subdate is '申购日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_jurisdate is '向一般法人配售上市日期';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_instisdate is '向战略投资者配售部分上市日期';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_expectlistdate is '预计上市日期';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_fundverificationdate is '申购资金验资日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_ratiodate is '中签率公布日';
comment on column ${iol_schema}.wind_ashareipo.s_fellow_unfrozedate is '申购资金解冻日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_listdate is '上市日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_puboffrdate is '招股公告日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_anncedate is '发行公告日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_anncelstdate is '上市公告日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_roadshowstartdate is '初步询价(预路演)起始日期';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_roadshowenddate is '初步询价(预路演)终止日期';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_placingdate is '网下配售发行公告日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_applystartdate is '网下申购起始日期';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_applyenddate is '网下申购截止日期';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_priceannouncedate is '网下定价公告日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_placingresultdate is '网下配售结果公告日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_fundenddate is '网下申购资金到帐截止日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_capverificationdate is '网下验资日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_refunddate is '网下多余款项退还日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_expectedcollection is '预计募集资金(万元)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_list_fee is '发行费用(万元)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_lpurnameonl is '';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_cashamtuplimit is '申购上限(机构)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_cashmoneyuplimit is '申购金额上限(机构)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_namebyplacing is '上网发行简称';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_showpricedownlimit is '投标询价申购价格下限';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_par is '面值';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_purchaseuplimit is '网上申购上限(个人)';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_op_uplimit is '网下申购上限';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_op_downlimit is '网下申购下限';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_purchasemv_dt is '网上市值申购登记日';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_pubosdtotisscoll is '公开及原股东募集资金总额';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_osdexpoffamount is '新股发行数量';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_osdexpoffamountup is '原股东预计售股数量上限';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_osdactoffamount is '原股东实际售股数量';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_osdactoffprice is '原股东实际售股金额';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_osdunderwritingfees is '原股东应摊承销费用';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_pureffsubratio is '网上投资者有效认购倍数';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_reporate is '回拨比例';
comment on column ${iol_schema}.wind_ashareipo.ann_dt is '最新公告日期';
comment on column ${iol_schema}.wind_ashareipo.is_failure is '是否发行失败';
comment on column ${iol_schema}.wind_ashareipo.s_ipo_otc_cash_pct is '网下申购配售比例';
comment on column ${iol_schema}.wind_ashareipo.min_applyunit is '';
comment on column ${iol_schema}.wind_ashareipo.opdate is '';
comment on column ${iol_schema}.wind_ashareipo.opmode is '';
comment on column ${iol_schema}.wind_ashareipo.start_dt is '开始时间';
comment on column ${iol_schema}.wind_ashareipo.end_dt is '结束时间';
comment on column ${iol_schema}.wind_ashareipo.id_mark is '增删标志';
comment on column ${iol_schema}.wind_ashareipo.etl_timestamp is 'ETL处理时间戳';
