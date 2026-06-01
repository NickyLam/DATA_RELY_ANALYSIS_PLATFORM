/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_sfggmxdgjk_data_administrative_cases
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,n_ssdw varchar2(4000) -- 诉讼地位
    ,n_ccxzxje varchar2(4000) -- 财产刑执行金额
    ,n_pcjg varchar2(4000) -- 判处结果
    ,c_gkws_glah varchar2(4000) -- 相关案件号
    ,n_sqbqse_level varchar2(4000) -- 申请保全数额等级
    ,n_pj_victory varchar2(4000) -- 胜诉估计
    ,n_wzxje varchar2(4000) -- 未执行金额
    ,c_gkws_dsr varchar2(4000) -- 当事人
    ,n_qsbdje_gj_level varchar2(4000) -- 起诉标的金额估计等级
    ,n_jbfy_cj varchar2(4000) -- 法院所属层级
    ,n_qsbdje varchar2(4000) -- 起诉标的金额
    ,n_slcx varchar2(4000) -- 审理程序
    ,n_ajjzjd varchar2(4000) -- 案件进展阶段
    ,n_jbfy varchar2(4000) -- 经办法院
    ,c_gkws_id varchar2(4000) -- 公开文书ID
    ,d_jarq varchar2(4000) -- 结案时间
    ,n_jabdje_level varchar2(4000) -- 结案标的金额等级
    ,c_slfsxx varchar2(4000) -- 审理方式信息
    ,n_ccxzxje_gj_level varchar2(4000) -- 财产刑执行金额估计等级
    ,n_pcpcje varchar2(4000) -- 判处赔偿金额
    ,n_sjdwje varchar2(4000) -- 实际到位金额
    ,n_fzje_level varchar2(4000) -- 犯罪金额等级
    ,n_pcpcje_level varchar2(4000) -- 判处赔偿金额等级
    ,c_sqbqbdw varchar2(4000) -- 申请保全标的物
    ,c_ah varchar2(4000) -- 案号
    ,n_qsbdje_level varchar2(4000) -- 起诉标的金额等级
    ,c_ssdy varchar2(4000) -- 所属地域
    ,n_jabdje varchar2(4000) -- 结案标的金额
    ,n_ajlx varchar2(4000) -- 案件类型
    ,n_laay varchar2(4000) -- 立案案由
    ,n_laay_tree varchar2(4000) -- 立案案由详细
    ,n_jaay varchar2(4000) -- 结案案由
    ,n_bqqpcje varchar2(4000) -- 被请求赔偿金额
    ,n_jabdje_gj varchar2(4000) -- 结案标的金额估计
    ,n_jaay_tree varchar2(4000) -- 结案案由详细
    ,n_jabdje_gj_level varchar2(4000) -- 结案标的金额估计等级
    ,n_pcpcje_gj varchar2(4000) -- 判处赔偿金额估计
    ,n_ccxzxje_level varchar2(4000) -- 财产刑执行金额等级
    ,n_ssdw_ys varchar2(4000) -- 一审诉讼地位
    ,n_pcpcje_gj_level varchar2(4000) -- 判处赔偿金额估计等级
    ,n_jafs varchar2(4000) -- 结案方式
    ,n_qsbdje_gj varchar2(4000) -- 起诉标的金额估计
    ,c_ah_hx varchar2(4000) -- 后续案号
    ,n_fzje varchar2(4000) -- 犯罪金额
    ,n_ccxzxje_gj varchar2(4000) -- 财产刑执行金额估计
    ,cases varchar2(4000) -- 关联标签
    ,n_dzzm varchar2(4000) -- 定罪罪名
    ,n_sqbqse varchar2(4000) -- 申请保全数额
    ,n_bqqpcje_level varchar2(4000) -- 被请求赔偿金额等级
    ,c_gkws_pjjg varchar2(4000) -- 判决结果
    ,n_laay_tag varchar2(4000) -- 立案案由标签
    ,n_jaay_tag varchar2(4000) -- 结案案由标签
    ,n_ajbs varchar2(4000) -- 案件标识
    ,n_dzzm_tree varchar2(4000) -- 定罪罪名树
    ,n_sqzxbdje varchar2(4000) -- 申请执行标的金额
    ,c_ah_ys varchar2(4000) -- 原审案号
    ,d_larq varchar2(4000) -- 立案时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases to ${iml_schema};
grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases to ${icl_schema};
grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases to ${idl_schema};
grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases is '司法研究院监控接口相关数据';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ssdw is '诉讼地位';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ccxzxje is '财产刑执行金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_pcjg is '判处结果';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_gkws_glah is '相关案件号';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_sqbqse_level is '申请保全数额等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_pj_victory is '胜诉估计';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_wzxje is '未执行金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_gkws_dsr is '当事人';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_qsbdje_gj_level is '起诉标的金额估计等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jbfy_cj is '法院所属层级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_qsbdje is '起诉标的金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_slcx is '审理程序';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ajjzjd is '案件进展阶段';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jbfy is '经办法院';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_gkws_id is '公开文书ID';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.d_jarq is '结案时间';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jabdje_level is '结案标的金额等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_slfsxx is '审理方式信息';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ccxzxje_gj_level is '财产刑执行金额估计等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_pcpcje is '判处赔偿金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_sjdwje is '实际到位金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_fzje_level is '犯罪金额等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_pcpcje_level is '判处赔偿金额等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_sqbqbdw is '申请保全标的物';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_ah is '案号';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_qsbdje_level is '起诉标的金额等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_ssdy is '所属地域';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jabdje is '结案标的金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ajlx is '案件类型';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_laay is '立案案由';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_laay_tree is '立案案由详细';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jaay is '结案案由';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_bqqpcje is '被请求赔偿金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jabdje_gj is '结案标的金额估计';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jaay_tree is '结案案由详细';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jabdje_gj_level is '结案标的金额估计等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_pcpcje_gj is '判处赔偿金额估计';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ccxzxje_level is '财产刑执行金额等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ssdw_ys is '一审诉讼地位';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_pcpcje_gj_level is '判处赔偿金额估计等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jafs is '结案方式';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_qsbdje_gj is '起诉标的金额估计';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_ah_hx is '后续案号';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_fzje is '犯罪金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ccxzxje_gj is '财产刑执行金额估计';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.cases is '关联标签';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_dzzm is '定罪罪名';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_sqbqse is '申请保全数额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_bqqpcje_level is '被请求赔偿金额等级';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_gkws_pjjg is '判决结果';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_laay_tag is '立案案由标签';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_jaay_tag is '结案案由标签';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_ajbs is '案件标识';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_dzzm_tree is '定罪罪名树';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.n_sqzxbdje is '申请执行标的金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.c_ah_ys is '原审案号';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.d_larq is '立案时间';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_administrative_cases.etl_timestamp is 'ETL处理时间戳';
