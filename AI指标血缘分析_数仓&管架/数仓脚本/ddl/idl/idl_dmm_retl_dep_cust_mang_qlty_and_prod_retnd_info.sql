/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info(
      etl_dt date -- 数据日期
      ,lp_id varchar2(60) -- 法人编号
      ,cust_id varchar2(4000) -- 客户号
      ,mas_belong_brch_id varchar2(4000) -- 管户归属分行编号
      ,mas_belong_brch_name varchar2(4000) -- 管户归属分行名称
      ,mas_belong_subrch_id varchar2(4000) -- 管户归属支行编号
      ,mas_belong_subrch_name varchar2(4000) -- 管户归属支行名称
      ,open_acct_tm timestamp(6) -- 开户时间
      ,open_acct_mon varchar2(4000) -- 开户月份
      ,if_allacct_close varchar2(4000) -- 是否所有账户已销户
      ,zer_monend_aum number(22,6) -- 第0个月末aum
      ,fir_monend_aum number(22,6) -- 第1个月末aum
      ,sec_monend_aum number(22,6) -- 第2个月末aum
      ,thi_monend_aum number(22,6) -- 第3个月末aum
      ,fou_monend_aum number(22,6) -- 第4个月末aum
      ,fif_monend_aum number(22,6) -- 第5个月末aum
      ,six_monend_aum number(22,6) -- 第6个月末aum
      ,sev_monend_aum number(22,6) -- 第7个月末aum
      ,eig_monend_aum number(22,6) -- 第8个月末aum
      ,nin_monend_aum number(22,6) -- 第9个月末aum
      ,ten_monend_aum number(22,6) -- 第10个月末aum
      ,ele_monend_aum number(22,6) -- 第11个月末aum
      ,twe_monend_aum number(22,6) -- 第12个月末aum
      ,zer_mon_retnd varchar2(4000) -- 第0个月留存
      ,fir_mon_retnd varchar2(4000) -- 第1个月留存
      ,sec_mon_retnd varchar2(4000) -- 第2个月留存
      ,thi_mon_retnd varchar2(4000) -- 第3个月留存
      ,fou_mon_retnd varchar2(4000) -- 第4个月留存
      ,fif_mon_retnd varchar2(4000) -- 第5个月留存
      ,six_mon_retnd varchar2(4000) -- 第6个月留存
      ,sev_mon_retnd varchar2(4000) -- 第7个月留存
      ,eig_mon_retnd varchar2(4000) -- 第8个月留存
      ,nin_mon_retnd varchar2(4000) -- 第9个月留存
      ,ten_mon_retnd varchar2(4000) -- 第10个月留存
      ,ele_mon_retnd varchar2(4000) -- 第11个月留存
      ,twe_mon_retnd varchar2(4000) -- 第12个月留存
      ,fir_prod_dt date -- 首单产品日期
      ,sec_prod_dt date -- 二单产品日期
      ,fir_and_scd_tran_intrv_mon varchar2(4000) -- 首次与二次交易间隔的月份
      ,fir_prod_type varchar2(4000) -- 首单产品类型
      ,sec_prod_type varchar2(4000) -- 二单产品类型
      ,fir_prod_id varchar2(4000) -- 首单产品编号
      ,sec_prod_id varchar2(4000) -- 二单产品编号
      ,fir_prod_name varchar2(4000) -- 首单产品名称
      ,sec_prod_name varchar2(4000) -- 二单产品名称
      ,sec_prod_cls varchar2(4000) -- 二单产品分类
      ,fir_prod_cls varchar2(4000) -- 首单产品分类
      ,fir_tran_prod_tenor number(10,0) -- 首单交易产品期限
      ,sec_tran_prod_tenor number(10,0) -- 二单交易产品期限
      ,fir_prod_risk_level varchar2(4000) -- 首单产品风险等级
      ,sec_prod_risk_level varchar2(4000) -- 二单产品风险等级
      ,job_cd varchar2(10) -- 任务代码
      ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info to ${idl_schema};
grant select on ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info to ${iel_schema};
grant select on ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info to ${dqc_schema};
-- comment
comment on table ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info is '零售存款客户经营质量与产品留存信息';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.etl_dt is '数据日期';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.lp_id is '法人编号';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.cust_id is '客户号';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.mas_belong_brch_id is '管户归属分行编号';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.mas_belong_brch_name is '管户归属分行名称';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.mas_belong_subrch_id is '管户归属支行编号';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.mas_belong_subrch_name is '管户归属支行名称';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.open_acct_tm is '开户时间';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.open_acct_mon is '开户月份';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.if_allacct_close is '是否所有账户已销户';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.zer_monend_aum is '第0个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_monend_aum is '第1个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_monend_aum is '第2个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.thi_monend_aum is '第3个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fou_monend_aum is '第4个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fif_monend_aum is '第5个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.six_monend_aum is '第6个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sev_monend_aum is '第7个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.eig_monend_aum is '第8个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.nin_monend_aum is '第9个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.ten_monend_aum is '第10个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.ele_monend_aum is '第11个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.twe_monend_aum is '第12个月末aum';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.zer_mon_retnd is '第0个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_mon_retnd is '第1个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_mon_retnd is '第2个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.thi_mon_retnd is '第3个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fou_mon_retnd is '第4个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fif_mon_retnd is '第5个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.six_mon_retnd is '第6个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sev_mon_retnd is '第7个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.eig_mon_retnd is '第8个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.nin_mon_retnd is '第9个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.ten_mon_retnd is '第10个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.ele_mon_retnd is '第11个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.twe_mon_retnd is '第12个月留存';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_prod_dt is '首单产品日期';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_prod_dt is '二单产品日期';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_and_scd_tran_intrv_mon is '首次与二次交易间隔的月份';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_prod_type is '首单产品类型';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_prod_type is '二单产品类型';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_prod_id is '首单产品编号';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_prod_id is '二单产品编号';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_prod_name is '首单产品名称';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_prod_name is '二单产品名称';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_prod_cls is '二单产品分类';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_prod_cls is '首单产品分类';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_tran_prod_tenor is '首单交易产品期限';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_tran_prod_tenor is '二单交易产品期限';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.fir_prod_risk_level is '首单产品风险等级';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.sec_prod_risk_level is '二单产品风险等级';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.job_cd is '任务代码';
comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.etl_timestamp is '数据处理时间';
--comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.etl_dt is 'ETL处理日期';
--comment on column ${idl_schema}.dmm_retl_dep_cust_mang_qlty_and_prod_retnd_info.etl_timestamp is 'ETL处理时间戳';
