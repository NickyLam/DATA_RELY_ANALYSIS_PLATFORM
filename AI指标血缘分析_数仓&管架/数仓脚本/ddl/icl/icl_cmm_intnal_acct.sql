/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_intnal_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_intnal_acct
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_intnal_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_intnal_acct(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,sub_acct_num varchar2(100) -- 子户号
    ,main_acct_id varchar2(60) -- 主账户编号
    ,acct_card_no varchar2(60) -- 账户卡号
    ,old_acct_id varchar2(60) -- 旧账户编号
    ,old_sub_acct_num varchar2(10) -- 旧子户号
    ,prod_id varchar2(100) -- 产品编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,curr_cd varchar2(10) -- 币种代码
    ,acct_name varchar2(500) -- 账户名称
    ,open_flow_num varchar2(100) -- 开户流水号
    ,clos_acct_flow_num varchar2(100) -- 销户流水号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,last_tran_dt date -- 上次交易日期
    ,last_tran_flow_num varchar2(100) -- 上次交易流水号
    ,accting_cd varchar2(30) -- 会计核算代码
    ,subj_id varchar2(60) -- 科目编号
    ,bal_dir_cd varchar2(10) -- 余额方向代码
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,acct_attr_cd varchar2(10) -- 账户属性代码
    ,open_acct_dt date -- 开户日期
    ,clos_acct_dt date -- 销户日期
    ,in_out_tab_flg varchar2(10) -- 表内外标志
    ,suspd_wrtoff_flg varchar2(10) -- 挂销账标志
    ,int_accr_flg varchar2(10) -- 计息标志
    ,travel_card_acct_flg varchar2(10) -- 旅行通账户标志
    ,travel_card_valid_dt date --旅行通卡有效期
    ,acct_cls_cd varchar2(10) -- 账户分类代码
    ,open_acct_chn_type_cd varchar2(10) -- 开户渠道编号
    ,reg_acct_type_cd varchar2(10) -- 定期账户类型代码
    ,bus_mgmt_cls_cd varchar2(500) -- 业务管理分类代码
    ,on_acct_tenor varchar2(10) -- 挂账期限
    ,wrtoff_way_cd varchar2(10) -- 销账方式代码
    ,bus_code_ser_num varchar2(60) -- 业务编码序列号
    ,gl_acct_flg varchar2(10) -- 总账账户标志
    ,intnal_acct_char_cd varchar2(10) -- 内部账户性质代码
    ,cap_char_cd varchar2(10) -- 资金性质代码
    ,acct_usage_cd varchar2(30) -- 账户用途代码
    ,last_modif_teller_id varchar2(100) -- 上次修改柜员编号
    ,acct_bal number(30,2) -- 账户余额
    ,cl_curr_acct_bal number(30,2) -- 折本币账户余额
    ,td_int_expns number(30,2) -- 当日利息支出
    ,int_expns_subj_id varchar2(100) -- 利息支出科目编号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,currt_acru_int number(30,8) -- 当期应计利息
    ,ear_d_bal number(30,2) -- 日初余额
    ,ear_m_bal number(30,2) -- 月初余额
    ,ear_s_bal number(30,2) -- 季初余额
    ,ear_y_bal number(30,2) -- 年初余额
    ,m_acm_bal number(30,2) -- 月累计余额
    ,s_acm_bal number(30,2) -- 季累计余额
    ,y_acm_bal number(30,2) -- 年累计余额
    ,cl_curr_ear_d_bal number(30,2) -- 折本币日初余额
    ,cl_curr_ear_m_bal number(30,2) -- 折本币月初余额
    ,cl_curr_ear_s_bal number(30,2) -- 折本币季初余额
    ,cl_curr_ear_y_bal number(30,2) -- 折本币年初余额
    ,cl_curr_y_acm_bal number(30,2) -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal number(30,2) -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal number(30,2) -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal number(30,2) -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal number(30,2) -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal number(30,2) -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal number(30,2) -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal number(30,2) -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal number(30,2) -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal number(30,2) -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal number(30,2) -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal number(30,2) -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal number(30,2) -- 折本币年初月累计余额
    ,y_avg_bal number(30,2) -- 年日均余额
    ,q_avg_bal number(30,2) -- 季日均余额
    ,m_avg_bal number(30,2) -- 月日均余额
    ,cl_curr_y_avg_bal number(30,2) -- 折本币年日均余额
    ,cl_curr_q_avg_bal number(30,2) -- 折本币季日均余额
    ,cl_curr_m_avg_bal number(30,2) -- 折本币月日均余额
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
grant select on ${icl_schema}.cmm_intnal_acct to ${idl_schema};
grant select on ${icl_schema}.cmm_intnal_acct to ${iel_schema};
grant select on ${icl_schema}.cmm_intnal_acct to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_intnal_acct is '内部账户';
comment on column ${icl_schema}.cmm_intnal_acct.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_intnal_acct.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_intnal_acct.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_intnal_acct.sub_acct_num is '子户号';
comment on column ${icl_schema}.cmm_intnal_acct.main_acct_id is '主账户编号';
comment on column ${icl_schema}.cmm_intnal_acct.acct_card_no is '账户卡号';
comment on column ${icl_schema}.cmm_intnal_acct.old_acct_id is '旧账户编号';
comment on column ${icl_schema}.cmm_intnal_acct.old_sub_acct_num is '旧子户号';
comment on column ${icl_schema}.cmm_intnal_acct.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_intnal_acct.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_intnal_acct.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_intnal_acct.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_intnal_acct.open_flow_num is '开户流水号';
comment on column ${icl_schema}.cmm_intnal_acct.clos_acct_flow_num is '销户流水号';
comment on column ${icl_schema}.cmm_intnal_acct.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_intnal_acct.last_tran_dt is '上次交易日期';
comment on column ${icl_schema}.cmm_intnal_acct.last_tran_flow_num is '上次交易流水号';
comment on column ${icl_schema}.cmm_intnal_acct.accting_cd is '会计核算代码';
comment on column ${icl_schema}.cmm_intnal_acct.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_intnal_acct.bal_dir_cd is '余额方向代码';
comment on column ${icl_schema}.cmm_intnal_acct.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_intnal_acct.acct_attr_cd is '账户属性代码';
comment on column ${icl_schema}.cmm_intnal_acct.open_acct_dt is '开户日期';
comment on column ${icl_schema}.cmm_intnal_acct.clos_acct_dt is '销户日期';
comment on column ${icl_schema}.cmm_intnal_acct.in_out_tab_flg is '表内外标志';
comment on column ${icl_schema}.cmm_intnal_acct.suspd_wrtoff_flg is '挂销账标志';
comment on column ${icl_schema}.cmm_intnal_acct.int_accr_flg is '计息标志';
comment on column ${icl_schema}.cmm_intnal_acct.travel_card_acct_flg is '旅行通账户标志';
comment on column ${icl_schema}.cmm_intnal_acct.travel_card_valid_dt is '旅行通卡有效期';
comment on column ${icl_schema}.cmm_intnal_acct.acct_cls_cd is '账户分类代码';
comment on column ${icl_schema}.cmm_intnal_acct.open_acct_chn_type_cd is '开户渠道编号';
comment on column ${icl_schema}.cmm_intnal_acct.reg_acct_type_cd is '定期账户类型代码';
comment on column ${icl_schema}.cmm_intnal_acct.bus_mgmt_cls_cd is '业务管理分类代码';
comment on column ${icl_schema}.cmm_intnal_acct.on_acct_tenor is '挂账期限';
comment on column ${icl_schema}.cmm_intnal_acct.wrtoff_way_cd is '销账方式代码';
comment on column ${icl_schema}.cmm_intnal_acct.bus_code_ser_num is '业务编码序列号';
comment on column ${icl_schema}.cmm_intnal_acct.gl_acct_flg is '总账账户标志';
comment on column ${icl_schema}.cmm_intnal_acct.intnal_acct_char_cd is '内部账户性质代码';
comment on column ${icl_schema}.cmm_intnal_acct.cap_char_cd is '资金性质代码';
comment on column ${icl_schema}.cmm_intnal_acct.acct_usage_cd is '账户用途代码';
comment on column ${icl_schema}.cmm_intnal_acct.last_modif_teller_id is '上次修改柜员编号';
comment on column ${icl_schema}.cmm_intnal_acct.acct_bal is '账户余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_acct_bal is '折本币账户余额';
comment on column ${icl_schema}.cmm_intnal_acct.td_int_expns is '当日利息支出';
comment on column ${icl_schema}.cmm_intnal_acct.int_expns_subj_id is '利息支出科目编号';
comment on column ${icl_schema}.cmm_intnal_acct.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_intnal_acct.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_intnal_acct.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_intnal_acct.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_intnal_acct.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_intnal_acct.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_intnal_acct.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${icl_schema}.cmm_intnal_acct.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_intnal_acct.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_intnal_acct.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${icl_schema}.cmm_intnal_acct.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${icl_schema}.cmm_intnal_acct.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_intnal_acct.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_intnal_acct.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_intnal_acct.etl_timestamp is 'ETL处理时间戳';
